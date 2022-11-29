# API

### Get started
- Make sure to specify correct constants in `Constants.swift`

### Folders structure
- Models: All public models
- Modules
    - Cached: Propery wrapper to persist data in cache (file storage)
    - Fetch: Library to interact with HTTP API's'
    - Render: Library to generate image URL (resize, screenshot, favicon)
- Rest: Methods to interact with Raindrop.io REST API
- Store: SwiftUI optimized Redux-like store with actions/reducers/state
