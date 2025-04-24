# AKS AI Demo

This project demonstrates a text summarization service deployed on Azure Kubernetes Service (AKS). It provides a web interface for users to input text and receive AI-generated summaries, with the ability to view query history.

It is meant to demo the features of building a simple AI application and deploying it to the cloud. The application itself is simple with direct HTML responses from the backend that speeds up request responses, the only part where real processing takes place being in the ML algorithm.

## Project Overview

The project consists of several components:

- **Python Server**: A Flask-based web application that provides text summarization using the T5 transformer model
- **Docker Support**: Containerized application for easy deployment
- **MongoDB Integration**: Stores query history and results
- **JMeter Testing**: Performance testing scripts included
- **Deployment Scripts**: Utilities for deploying to AKS with Bicep

## Features

- Text summarization using the T5 transformer model
- Web interface for easy interaction
- Query history tracking
- Containerized deployment
- Performance testing capabilities

## Prerequisites

- Python 3.x
- Docker
- Azure CLI
- kubectl
- MongoDB connection string
- Azure Kubernetes Service cluster

## Setup Instructions

1. Clone the repository
2. Install dependencies:
   ```bash
   cd pythonServer
   pip install -r requirements.txt
   ```

3. Set up environment variables:
   - `MONGO_DB_CONNECTION_STRING`: Your MongoDB connection string
   - `PORT_NUMBER`: Port number for the server (default: 5000)

4. Build and run the Docker container:
   ```bash
   docker build -t aks-ai-demo .
   docker run -p 5000:5000 -e MONGO_DB_CONNECTION_STRING=your_connection_string aks-ai-demo
   ```

## Deployment to AKS

The project includes scripts for deploying to Azure Kubernetes Service. Refer to the `scripts` directory for deployment instructions.

## Testing

JMeter test files are included in the `jMeterFiles` directory for performance testing.

## Project Structure

```
.
├── pythonServer/         # Main application code
│   ├── server.py        # Flask application
│   ├── Dockerfile       # Container configuration
│   └── requirements.txt # Python dependencies
├── scripts/             # Deployment and utility scripts
├── jMeterFiles/         # Performance testing configurations
└── poze/               # Project images and documentation
```

## License

This project is part of the Cloud Computing Technologies for ML Workloads class.

## Author

Gherca Darius