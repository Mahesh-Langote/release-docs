#!/bin/bash

# Simple validation script for action.yml

echo "🔍 Validating action.yml structure..."

# Check if action.yml exists
if [[ ! -f "action.yml" ]]; then
    echo "❌ action.yml not found!"
    exit 1
fi

# Basic YAML validation using Python
if command -v python3 &> /dev/null; then
    python3 -c "
import yaml
import sys

try:
    with open('action.yml', 'r') as f:
        data = yaml.safe_load(f)
    
    # Check required fields
    required_fields = ['name', 'description', 'runs']
    for field in required_fields:
        if field not in data:
            print(f'❌ Missing required field: {field}')
            sys.exit(1)
    
    # Check if runs.using is set to composite
    if data['runs']['using'] != 'composite':
        print(f'❌ Invalid runs.using value: {data[\"runs\"][\"using\"]}')
        sys.exit(1)
    
    # Check if steps exist
    if 'steps' not in data['runs']:
        print('❌ No steps defined in runs')
        sys.exit(1)
    
    step_count = len(data['runs']['steps'])
    print(f'✅ action.yml is valid YAML')
    print(f'✅ Found {step_count} steps')
    print(f'✅ Action name: {data[\"name\"]}')
    print(f'✅ Action type: {data[\"runs\"][\"using\"]}')
    
except yaml.YAMLError as e:
    print(f'❌ YAML syntax error: {e}')
    sys.exit(1)
except Exception as e:
    print(f'❌ Validation error: {e}')
    sys.exit(1)
"
else
    echo "⚠️ Python3 not available, skipping detailed validation"
fi

echo "✅ Basic validation completed!"
