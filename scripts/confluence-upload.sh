#!/bin/bash

# Smart Release Documentation Generator - Confluence Upload Script
# Uploads release notes to Confluence using REST API

upload_to_confluence() {
    echo "📤 Uploading release notes to Confluence..."
    
    # Validate required environment variables
    if [ -z "$CONFLUENCE_BASE_URL" ] || [ -z "$CONFLUENCE_EMAIL" ] || [ -z "$CONFLUENCE_API_TOKEN" ]; then
        echo "❌ Missing required Confluence configuration"
        echo "Please set: CONFLUENCE_BASE_URL, CONFLUENCE_EMAIL, CONFLUENCE_API_TOKEN"
        exit 1
    fi
    
    local page_title="Release Notes - ${PROJECT_NAME:-Project} v${APP_VERSION}"
    local space_key="${CONFLUENCE_SPACE_KEY:-DEV}"
    local confluence_content="$CONFLUENCE_CONTENT"
    
    # Function to make HTTP requests to Confluence API
    make_confluence_request() {
        local method="$1"
        local endpoint="$2"
        local data="$3"
        
        local auth_header="Authorization: Basic $(echo -n "$CONFLUENCE_EMAIL:$CONFLUENCE_API_TOKEN" | base64 -w 0)"
        local content_type="Content-Type: application/json"
        
        if [ -n "$data" ]; then
            curl -s -X "$method" \
                 -H "$auth_header" \
                 -H "$content_type" \
                 -d "$data" \
                 "$CONFLUENCE_BASE_URL/rest/api/$endpoint"
        else
            curl -s -X "$method" \
                 -H "$auth_header" \
                 -H "$content_type" \
                 "$CONFLUENCE_BASE_URL/rest/api/$endpoint"
        fi
    }
    
    # Search for existing page
    echo "🔍 Checking for existing page..."
    local encoded_title=$(printf '%s' "$page_title" | jq -sRr @uri)
    local search_response=$(make_confluence_request "GET" "content?title=$encoded_title&spaceKey=$space_key&expand=version")
    
    # Parse search results
    local existing_page_id=$(echo "$search_response" | jq -r '.results[0].id // empty')
    local existing_version=$(echo "$search_response" | jq -r '.results[0].version.number // empty')
    
    # Prepare page data
    local page_data
    local method
    local endpoint
    
    if [ -n "$existing_page_id" ]; then
        echo "📝 Updating existing page (ID: $existing_page_id)"
        method="PUT"
        endpoint="content/$existing_page_id"
        
        # Calculate new version number
        local new_version=$((existing_version + 1))
        
        page_data=$(jq -n \
            --arg id "$existing_page_id" \
            --arg title "$page_title" \
            --arg space_key "$space_key" \
            --arg content "$confluence_content" \
            --arg version "$new_version" \
            '{
                id: $id,
                type: "page",
                title: $title,
                space: {key: $space_key},
                version: {number: ($version | tonumber)},
                body: {
                    wiki: {
                        value: $content,
                        representation: "wiki"
                    }
                }
            }')
    else
        echo "📄 Creating new page"
        method="POST"
        endpoint="content"
        
        page_data=$(jq -n \
            --arg title "$page_title" \
            --arg space_key "$space_key" \
            --arg content "$confluence_content" \
            --arg parent_id "$CONFLUENCE_PARENT_PAGE_ID" \
            '{
                type: "page",
                title: $title,
                space: {key: $space_key},
                body: {
                    wiki: {
                        value: $content,
                        representation: "wiki"
                    }
                }
            } + (if $parent_id and $parent_id != "" then {ancestors: [{id: $parent_id}]} else {} end)')
    fi
    
    # Upload to Confluence
    echo "🚀 Uploading content to Confluence..."
    local upload_response=$(make_confluence_request "$method" "$endpoint" "$page_data")
    
    # Check for errors
    local error_message=$(echo "$upload_response" | jq -r '.message // empty')
    if [ -n "$error_message" ]; then
        echo "❌ Upload failed: $error_message"
        echo "Response: $upload_response"
        exit 1
    fi
    
    # Extract page information
    local page_id=$(echo "$upload_response" | jq -r '.id')
    local page_url="$CONFLUENCE_BASE_URL/spaces/$space_key/pages/$page_id"
    
    if [ -n "$page_id" ]; then
        echo "✅ Successfully uploaded to Confluence!"
        echo "📄 Page ID: $page_id"
        echo "🔗 Page URL: $page_url"
        
        # Set environment variables for other steps
        echo "CONFLUENCE_URL=$page_url" >> $GITHUB_ENV
        echo "CONFLUENCE_PAGE_ID=$page_id" >> $GITHUB_ENV
        
        # Add to release highlights
        local current_highlights="$RELEASE_HIGHLIGHTS"
        local new_highlights="${current_highlights}\\n• 📖 Documentation: [Confluence]($page_url)"
        echo "RELEASE_HIGHLIGHTS=$new_highlights" >> $GITHUB_ENV
        
    else
        echo "❌ Failed to extract page ID from response"
        echo "Response: $upload_response"
        exit 1
    fi
}

# Helper function to validate Confluence connectivity
test_confluence_connection() {
    echo "🔍 Testing Confluence connection..."
    
    local test_response=$(make_confluence_request "GET" "space")
    local error_message=$(echo "$test_response" | jq -r '.message // empty')
    
    if [ -n "$error_message" ]; then
        echo "❌ Confluence connection failed: $error_message"
        return 1
    else
        echo "✅ Confluence connection successful"
        return 0
    fi
}

# Helper function to get space information
get_space_info() {
    local space_key="$1"
    
    echo "📋 Getting space information for: $space_key"
    local space_response=$(make_confluence_request "GET" "space/$space_key")
    
    local space_name=$(echo "$space_response" | jq -r '.name // "Unknown"')
    local space_homepage=$(echo "$space_response" | jq -r '.homepage.id // empty')
    
    echo "Space: $space_name"
    if [ -n "$space_homepage" ]; then
        echo "Homepage ID: $space_homepage"
    fi
}
