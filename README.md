# API Dashboard

## 📖 Description
RESTful API and admin dashboard for crawler management.

## 🛠 Tech Stack
- Node.js / TypeScript
- Express/NestJS
- PostgreSQL

## 🔗 API Documentation
[Link to API documentation]

## 🚀 Setup Instructions
```bash
# Coming soon
```

## 🌐 Environment Variables
- `DB_HOST`: Database host
- `DB_PORT`: Database port
- `DB_USER`: Database user
- `DB_PASSWORD`: Database password
- `API_KEY`: API key for external services

### Docker setup
# Trong thư mục api-dashboard
docker build -t api-dashboard:local .
docker run -p 4000:4000 --rm api-dashboard:local
# Truy cập http://localhost:4000/api/health → {"status":"ok"}