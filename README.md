# Maccabi iOS Exercise

Developed by Nimrod Yizhar.
The application utilizes the MVVM architecture and is built with SwiftUI. It is a browsable product catalog organized by categories.

## Features

- **Categories View**: Users can browse through various product categories.
- **Products Of Category View**: For each selected category, the app presents a detailed view of all products.

## Data Management

- **Products Service**: This service fetches products data from a remote source at [DummyJSON](https://dummyjson.com/products).
- **Local Caching**: A file-based local caching service is used by the Products Service to store product information.

## Architecture

- **ViewModel**: The ViewModel interacts with the Products service to fetch data and builds two types of display models:
  - **Categories Array**: Display model for showing details of each category, including their accumulated products information.
  - **Products of Categories Dictionary**: For showing details of all products in each category.
