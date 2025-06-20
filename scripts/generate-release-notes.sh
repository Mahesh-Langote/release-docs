#!/bin/bash

# Smart Release Documentation Generator - Release Notes Generation Script
# This script generates comprehensive release notes from git commits

generate_release_notes() {
    echo "🔍 Starting release notes generation..."
    
    # Initialize variables
    local commit_range=""
    local commit_count=0
    local ticket_count=0
    
    # Create output directory
    mkdir -p release-notes
    
    # Determine commit range
    determine_commit_range() {
        if [ -n "$COMMIT_RANGE" ]; then
            commit_range="$COMMIT_RANGE"
            echo "📌 Using provided commit range: $commit_range"
        else
            echo "🔍 Auto-detecting commit range..."
            
            # Look for previous release tags
            local previous_tag=$(git tag -l | grep -E "(release|Release|v[0-9])" | sort -V | tail -1 2>/dev/null || echo "")
            
            if [ -n "$previous_tag" ]; then
                commit_range="${previous_tag}..HEAD"
                echo "📌 Found previous release tag: $previous_tag"
                echo "📌 Using tag-based range: $commit_range"
            else
                # Fallback to recent commits
                local total_commits=$(git rev-list --count HEAD)
                local max_commits=${MAX_COMMITS:-100}
                
                if [ "$total_commits" -gt "$max_commits" ]; then
                    commit_range="HEAD~${max_commits}..HEAD"
                    echo "📌 Using last $max_commits commits: $commit_range"
                else
                    commit_range="HEAD~${total_commits}..HEAD"
                    echo "📌 Using all $total_commits commits: $commit_range"
                fi
            fi
        fi
        
        # Validate commit range
        commit_count=$(git rev-list --count $commit_range 2>/dev/null || echo "0")
        echo "✅ Found $commit_count commits in range: $commit_range"
        
        if [ "$commit_count" -eq "0" ]; then
            echo "⚠️ No commits found in range, using fallback"
            commit_range="HEAD~10..HEAD"
            commit_count=$(git rev-list --count $commit_range)
        fi
    }
    
    # Extract tickets from commits
    extract_tickets() {
        echo "🎫 Extracting tickets from commits..."
        
        local tickets=$(git log $commit_range --pretty=format:"%s%n%b" 2>/dev/null | \
                       grep -oE "$TICKET_PATTERN" | sort -u || echo "")
        
        ticket_count=$(echo "$tickets" | grep -v '^$' | wc -l || echo "0")
        echo "✅ Found $ticket_count unique tickets"
        
        # Store tickets in environment
        if [ "$ticket_count" -gt 0 ]; then
            local tickets_list=$(echo "$tickets" | tr '\n' ', ' | sed 's/,$//')
            echo "TICKETS_LIST=$tickets_list" >> $GITHUB_ENV
        else
            echo "TICKETS_LIST=No tickets found" >> $GITHUB_ENV
        fi
        
        echo "TICKET_COUNT=$ticket_count" >> $GITHUB_ENV
    }
    
    # Format commit message with ticket links
    format_commit_message() {
        local commit_message="$1"
        local commit_hash="$2"
        
        # Extract ticket from message
        local ticket=$(echo "$commit_message" | grep -oE "$TICKET_PATTERN" | head -1)
        
        if [ -n "$ticket" ]; then
            # Create clickable link
            local ticket_url="${TICKET_BASE_URL}${ticket}"
            local formatted_message=$(echo "$commit_message" | \
                                    sed "s/$ticket/[$ticket]($ticket_url)/" | \
                                    tr '\n' ' ' | sed 's/  */ /g' | sed 's/^ *//' | sed 's/ *$//')
            echo "$formatted_message"
        else
            # Clean message without ticket
            local cleaned_message=$(echo "$commit_message" | \
                                  tr '\n' ' ' | sed 's/  */ /g' | sed 's/^ *//' | sed 's/ *$//')
            echo "$cleaned_message"
        fi
    }
    
    # Process commits by category
    process_category() {
        local category_name="$1"
        local keywords="$2"
        local output_section="$3"
        local max_entries="${4:-30}"
        
        echo "📂 Processing category: $category_name"
        
        local temp_file=$(mktemp)
        local processed_file=$(mktemp)
        
        # Process commits
        git log $commit_range --pretty=format:"%H|||%s|||%b" 2>/dev/null | \
        while IFS='|||' read -r hash subject body; do
            if [ -z "$hash" ]; then continue; fi
            
            # Skip if already processed
            if grep -q "^$hash$" "$processed_file" 2>/dev/null; then
                continue
            fi
            
            # Check if commit matches category keywords
            local matches=false
            IFS='|' read -ra KEYWORD_ARRAY <<< "$keywords"
            for keyword in "${KEYWORD_ARRAY[@]}"; do
                if echo "$subject" | grep -qiE "\\b${keyword}"; then
                    matches=true
                    break
                fi
                if [ -n "$body" ] && echo "$body" | grep -qiE "\\b${keyword}"; then
                    matches=true
                    break
                fi
            done
            
            if [ "$matches" = true ]; then
                # Format the commit message
                local full_message="${subject}"
                if [ -n "$body" ]; then
                    full_message="${subject} ${body}"
                fi
                
                local formatted_msg=$(format_commit_message "$full_message" "$hash")
                echo "* $formatted_msg" >> "$temp_file"
                echo "$hash" >> "$processed_file"
                
                # Check max entries limit
                local entry_count=$(wc -l < "$temp_file" 2>/dev/null || echo "0")
                if [ "$entry_count" -ge "$max_entries" ]; then
                    break
                fi
            fi
        done
        
        # Add to release notes
        echo -e "\\n### $output_section" >> "release-notes/release-notes-v${APP_VERSION}.md"
        
        if [ -f "$temp_file" ] && [ -s "$temp_file" ]; then
            cat "$temp_file" >> "release-notes/release-notes-v${APP_VERSION}.md"
            local added_count=$(wc -l < "$temp_file")
            echo "✅ Added $added_count entries to $category_name"
        else
            echo "* No $category_name in this release" >> "release-notes/release-notes-v${APP_VERSION}.md"
            echo "ℹ️ No entries found for $category_name"
        fi
        
        # Cleanup
        rm -f "$temp_file" "$processed_file"
    }
    
    # Main execution
    determine_commit_range
    extract_tickets
    
    # Create release notes header
    cat > "release-notes/release-notes-v${APP_VERSION}.md" << EOF
# Release Notes - v${APP_VERSION}

**Release Date:** $(date +'%B %d, %Y')  
**Version:** v${APP_VERSION}  
**Commits Analyzed:** $commit_count  
**Commit Range:** \`$commit_range\`  
**Tickets Found:** $ticket_count  

## Summary

This release includes $commit_count commits with $ticket_count unique tickets.
EOF
    
    # Process categories if enabled
    if [ "$ENABLE_CATEGORIES" = "true" ]; then
        echo "📋 Processing commit categories..."
        
        # Check for custom category configuration
        if [ -n "${{ inputs.category-config }}" ]; then
            echo "Using custom category configuration"
            # Parse JSON config (simplified)
            # This would need proper JSON parsing in production
        else
            # Default categories
            process_category "new features" "feat|feature|add|new|implement|introduce" "🚀 New Features" 20
            process_category "bug fixes" "fix|bug|issue|resolve|solved|hotfix|patch" "🐛 Bug Fixes" 25
            process_category "performance improvements" "perf|performance|optimize|speed|improve|enhancement" "⚡ Performance Improvements" 15
            process_category "refactoring" "refactor|refactored|refactoring|clean|cleanup|restructure" "♻️ Code Refactoring" 15
            process_category "documentation" "docs|documentation|comment|readme|guide" "📚 Documentation" 10
            process_category "styling" "style|ui|css|design|layout|theme" "💄 Styling & UI" 10
            process_category "configuration" "chore|config|build|ci|setup|install" "🔧 Configuration & Build" 10
            process_category "testing" "test|spec|coverage|unit|integration" "🧪 Testing" 10
        fi
    fi
    
    # Add summary section
    if [ "$INCLUDE_SUMMARY" = "true" ]; then
        cat >> "release-notes/release-notes-v${APP_VERSION}.md" << EOF

## 📊 Release Statistics

* **Total Commits:** $commit_count
* **Unique Tickets:** $ticket_count
* **Commit Range:** \`$commit_range\`
* **Generated:** $(date +'%Y-%m-%d %H:%M:%S UTC')
* **Generated By:** ${COMMITTER_NAME}

EOF
        
        if [ "$ticket_count" -gt 0 ]; then
            echo "### 🎫 Tickets in This Release" >> "release-notes/release-notes-v${APP_VERSION}.md"
            echo "" >> "release-notes/release-notes-v${APP_VERSION}.md"
            echo "${TICKETS_LIST}" | tr ',' '\n' | while read -r ticket; do
                if [ -n "$ticket" ]; then
                    echo "* [$ticket](${TICKET_BASE_URL}${ticket})" >> "release-notes/release-notes-v${APP_VERSION}.md"
                fi
            done
        fi
    fi
    
    # Set environment variables for other steps
    echo "TOTAL_COMMITS_ANALYZED=$commit_count" >> $GITHUB_ENV
    echo "COMMIT_RANGE_USED=$commit_range" >> $GITHUB_ENV
    
    # Create release highlights for notifications
    local highlights="📦 Release v${APP_VERSION} Summary:\\n"
    highlights+="• Analyzed $commit_count commits\\n"
    highlights+="• Found $ticket_count unique tickets\\n"
    highlights+="• Commit range: $commit_range"
    
    echo "RELEASE_HIGHLIGHTS=$highlights" >> $GITHUB_ENV
    
    echo "✅ Release notes generation completed!"
    echo "📄 Generated file: release-notes/release-notes-v${APP_VERSION}.md"
}
