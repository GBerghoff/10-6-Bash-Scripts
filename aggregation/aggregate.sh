#!/bin/bash

# Aggregation script for 10^6 Bash Scripts
# This script scans the scripts directory, finds all markdown files,
# and copies them to the Docusaurus docs directory with proper formatting

set -e

# Configuration
SCRIPTS_DIR="../scripts"
DOCS_DIR="../website/docs/scripts"
SIDEBAR_FILE="../website/sidebars.ts"

# Create docs directory if it doesn't exist
mkdir -p "$DOCS_DIR"

# Function to convert path to category name
path_to_category() {
  local path=$1
  # Remove leading "../scripts/" and trailing "/"
  local category=${path#"$SCRIPTS_DIR/"}
  category=${category%/}
  # Replace slashes with dashes for the ID
  echo "$category"
}

# Function to process a markdown file
process_markdown() {
  local md_file=$1
  local relative_path=${md_file#"$SCRIPTS_DIR/"}
  local parent_dir=$(dirname "$(dirname "$relative_path")")
  local script_name=$(basename "$(dirname "$relative_path")")
  local md_name=$(basename "$md_file")
  
  # If the markdown file is in a folder with the same name as the file (without extension),
  # place it directly in the parent folder
  if [ "$script_name" = "$(basename "$md_name" .md)" ]; then
    # Place in parent directory
    local doc_dir="$DOCS_DIR/$parent_dir"
    local doc_file="$doc_dir/$md_name"
    # Store the mapping for sidebar generation
    echo "$relative_path:$parent_dir/$md_name" >> "$DOCS_DIR/path_mapping.txt"
  else
    # Normal case - keep the original structure
    local doc_dir="$DOCS_DIR/$(dirname "$relative_path")"
    local doc_file="$doc_dir/$(basename "$md_file")"
    # Store the mapping for sidebar generation
    echo "$relative_path:$relative_path" >> "$DOCS_DIR/path_mapping.txt"
  fi
  
  # Create directory if it doesn't exist
  mkdir -p "$doc_dir"
  
  # Check if the file already has frontmatter
  if grep -q "^---" "$md_file"; then
    # File already has frontmatter, just copy it
    cp "$md_file" "$doc_file"
  else
    # Add frontmatter to the file
    local title=$(basename "$md_file" .md | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
    local id=$(basename "$md_file" .md)
    
    {
      echo "---"
      echo "id: $id"
      echo "title: $title"
      echo "description: Documentation for $title"
      echo "sidebar_position: 1"
      echo "---"
      echo ""
      cat "$md_file"
    } > "$doc_file"
  fi
  
  echo "Processed: $relative_path -> $doc_file"
}

# Function to get the correct doc path from the mapping file
get_doc_path() {
  local original_path=$1
  if [ -f "$DOCS_DIR/path_mapping.txt" ]; then
    local mapped_path=$(grep "^$original_path:" "$DOCS_DIR/path_mapping.txt" | cut -d':' -f2)
    if [ -n "$mapped_path" ]; then
      # Remove .md extension for Docusaurus document ID
      echo "scripts/${mapped_path%.md}"
    else
      echo "scripts/${original_path%.md}"
    fi
  else
    echo "scripts/${original_path%.md}"
  fi
}

# Function to build sidebar structure recursively
build_sidebar_structure() {
  local base_dir=$1
  local indent=$2
  
  # Process all markdown files directly in this directory
  find "$base_dir" -maxdepth 1 -type f -name "*.md" | sort | while read -r md_file; do
    local relative_path=${md_file#"$SCRIPTS_DIR/"}
    local doc_path=$(get_doc_path "$relative_path")
    echo "${indent}'$doc_path',"
  done
  
  # Process subdirectories
  find "$base_dir" -mindepth 1 -maxdepth 1 -type d | sort | while read -r dir; do
    # Skip if there are no markdown files in this directory or its subdirectories
    if [ -z "$(find "$dir" -name "*.md")" ]; then
      continue
    fi
    
    local dir_name=$(basename "$dir")
    local label=$(echo "$dir_name" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
    
    # Check if this directory contains a markdown file with the same name
    local has_matching_md=false
    local matching_md_path=""
    
    for md_file in "$dir"/*.md; do
      if [ -f "$md_file" ]; then
        local md_basename=$(basename "$md_file" .md)
        if [ "$md_basename" = "$dir_name" ]; then
          has_matching_md=true
          matching_md_path=${md_file#"$SCRIPTS_DIR/"}
          break
        fi
      fi
    done
    
    # If there's a matching markdown file, add it directly to the parent level
    # and skip creating a category for this directory
    if [ "$has_matching_md" = true ]; then
      local doc_path=$(get_doc_path "$matching_md_path")
      echo "${indent}'$doc_path',"
    else
      echo "${indent}{"
      echo "${indent}  type: 'category',"
      echo "${indent}  label: '$label',"
      echo "${indent}  items: ["
      
      # Recursively build sidebar for subdirectory
      build_sidebar_structure "$dir" "${indent}    "
      
      echo "${indent}  ],"
      echo "${indent}},"
    fi
  done
}

# Main script

echo "Starting aggregation process..."

# Clean up existing docs directory to avoid stale files
rm -rf "$DOCS_DIR"
mkdir -p "$DOCS_DIR"

# Create a file to store path mappings
touch "$DOCS_DIR/path_mapping.txt"

# Process all markdown files in the scripts directory
find "$SCRIPTS_DIR" -name "*.md" | while read -r md_file; do
  process_markdown "$md_file"
done

# Generate index.md for the scripts section if it doesn't exist
if [ ! -f "$DOCS_DIR/index.md" ]; then
  cat > "$DOCS_DIR/index.md" << EOF
---
id: scripts-index
title: Script Index
description: Collection of CI/CD and utility shell scripts
sidebar_position: 1
slug: /scripts
---

# 10^6 Bash Scripts

Welcome to the 10^6 Bash Scripts documentation. This is a collection of CI/CD and utility shell scripts.

## Categories

Browse scripts by category:

$(find "$SCRIPTS_DIR" -mindepth 1 -maxdepth 1 -type d | sort | while read -r dir; do
  if [ -n "$(find "$dir" -name "*.md")" ]; then
    echo "- [$(basename "$dir" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')](scripts/$(basename "$dir"))"
  fi
done)
EOF

  echo "Created index.md for scripts section"
fi

# Update sidebar.ts
# First, create a backup
cp "$SIDEBAR_FILE" "${SIDEBAR_FILE}.bak"

# Generate new sidebar content
cat > "$SIDEBAR_FILE" << EOF
import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  // By default, Docusaurus generates a sidebar from the docs folder structure
  tutorialSidebar: [
    'intro',
    {
      type: 'category',
      label: 'Scripts',
      items: [
        'scripts/scripts-index',
$(build_sidebar_structure "$SCRIPTS_DIR" "        ")
      ],
    },
    {
      type: 'category',
      label: 'Tutorial',
      items: [
        {
          type: 'autogenerated',
          dirName: 'tutorial-basics',
        },
      ],
    },
    {
      type: 'category',
      label: 'Advanced',
      items: [
        {
          type: 'autogenerated',
          dirName: 'tutorial-extras',
        },
      ],
    },
  ],
};

export default sidebars;
EOF

# Clean up the mapping file
rm -f "$DOCS_DIR/path_mapping.txt"

echo "Updated sidebar configuration"
echo "Aggregation complete!" 