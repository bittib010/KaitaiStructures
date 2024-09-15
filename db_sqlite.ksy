meta:
  id: sqlite3_db
  file-extension: sqlite
  endian: be
  description: "SQLite database file format structure"

seq:
  - id: header
    type: header
  - id: pages
    type: page
    repeat: eos # Read pages until the end of the file

types:
  header:
    seq:
      - id: magic
        contents: 'SQLite format 3\0'
        doc: "The SQLite magic string"
      - id: page_size
        type: u2
        doc: |
          The database page size in bytes. If the value is 1, the page size is 65536.
      - id: file_format_write_version
        type: u1
        doc: "File format write version."
      - id: file_format_read_version
        type: u1
        doc: "File format read version."
      - id: reserved_space
        type: u1
        doc: "Bytes of unused space reserved at the end of each page."
      - id: max_embedded_payload_frac
        type: u1
        doc: "Maximum embedded payload fraction (must be 64)."
      - id: min_embedded_payload_frac
        type: u1
        doc: "Minimum embedded payload fraction (must be 32)."
      - id: leaf_payload_frac
        type: u1
        doc: "Leaf payload fraction (must be 32)."
      - id: file_change_counter
        type: u4
        doc: "A counter incremented with each change to the database."
      - id: page_count
        type: u4
        doc: "Total number of pages in the database."
      - id: first_freelist_trunk_page
        type: u4
        doc: "Page number of the first freelist trunk page."
      - id: total_freelist_pages
        type: u4
        doc: "Total number of freelist pages."
      - id: schema_cookie
        type: u4
        doc: "Schema cookie."
      - id: schema_format_number
        type: u4
        doc: "Schema format number (1, 2, 3, or 4)."
      - id: default_page_cache_size
        type: u4
        doc: "Default page cache size."
      - id: largest_root_btree_page
        type: u4
        doc: "Page number of the largest root b-tree page."
      - id: text_encoding
        type: u4
        doc: |
          Text encoding used in the database:
          1: UTF-8
          2: UTF-16le
          3: UTF-16be
      - id: user_version
        type: u4
        doc: "User version number set by PRAGMA user_version."
      - id: incremental_vacuum_mode
        type: u4
        doc: "Incremental vacuum mode (0: disabled, 1: enabled)."
      - id: application_id
        type: u4
        doc: "Application ID set by PRAGMA application_id."
      - id: reserved
        type: bytes
        size: 20
        doc: "Reserved space for future use."
      - id: version_valid_for
        type: u4
        doc: "The version-valid-for number."
      - id: sqlite_version
        type: u4
        doc: "SQLite version number."
    instances:
      page_size_actual:
        value: 'page_size == 1 ? 65536 : page_size'

  page:
    doc: "SQLite database page."
    seq:
      - id: page_header
        type: page_header
      - id: cell_pointers
        type: u2
        repeat: expr
        repeat-expr: page_header.cell_count
        doc: "Offsets to the cells."
      - id: cells
        type: cell
        repeat: expr
        repeat-expr: page_header.cell_count
        doc: "Cell contents."
    types:
      page_header:
        seq:
          - id: page_type
            type: u1
            doc: |
              Page type:
              0x02: Interior index b-tree page
              0x05: Interior table b-tree page
              0x0A: Leaf index b-tree page
              0x0D: Leaf table b-tree page
          - id: first_freeblock
            type: u2
            doc: "Offset to the first freeblock."
          - id: cell_count
            type: u2
            doc: "Number of cells on this page."
          - id: cell_content_area
            type: u2
            doc: "Offset to the start of the cell content area."
          - id: fragmented_free_bytes
            type: u1
            doc: "Number of fragmented free bytes."
          - id: right_most_pointer
            type: u4
            if: is_interior_page
            doc: "Right-most pointer (only in interior pages)."
        instances:
          is_interior_page:
            value: 'page_type == 0x02 or page_type == 0x05'
          header_size:
            value: 'is_interior_page ? 12 : 8'

  cell:
    doc: "SQLite b-tree cell."
    seq:
      - id: left_child_page
        type: u4
        if: is_interior_page
        doc: "Left child page number (only in interior pages)."
      - id: payload_size
        type: vlq_base128_be
        if: has_payload
        doc: "Payload size."
      - id: row_id
        type: vlq_base128_be
        if: is_table_btree
        doc: "Row ID (only in table b-trees)."
      - id: payload
        size: payload_size
        if: has_payload
        doc: "Payload data."
    instances:
      is_interior_page:
        value: '_parent.page_header.page_type == 0x02 or _parent.page_header.page_type == 0x05'
      is_table_btree:
        value: '_parent.page_header.page_type == 0x05 or _parent.page_header.page_type == 0x0D'
      has_payload:
        value: '_parent.page_header.page_type == 0x0A or _parent.page_header.page_type == 0x0D'

  freelist_trunk_page:
    doc: "Freelist trunk page."
    seq:
      - id: next_trunk_page
        type: u4
        doc: "Page number of the next freelist trunk page."
      - id: leaf_page_count
        type: u4
        doc: "Number of leaf pages in the freelist."
      - id: leaf_page_numbers
        type: u4
        repeat: expr
        repeat-expr: leaf_page_count
        doc: "Page numbers of the freelist leaf pages." 
