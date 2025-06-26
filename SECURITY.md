# Security Implementation

## Overview
This Rails 8 Budget Tracker application implements enterprise-level security measures to protect user data and prevent common web vulnerabilities.

## Authentication & Authorization

### Route Security
- **Root Route (/)**: Public access - shows landing page for non-authenticated users, redirects authenticated users to dashboard
- **Authentication Routes**: Public access for login/signup forms
- **Protected Routes**: All budget management routes require authentication:
  - `/dashboard` - Main application dashboard
  - `/categories` - Category management
  - `/transactions` - Transaction management  
  - `/budgets` - Budget plan management
  - `/users/:id/*` - User profile management (with correct user validation)

### API Security
- **API Endpoints**: All API routes under `/api/v1/` require authentication
- **JSON Responses**: Proper 401 Unauthorized responses for unauthenticated API requests
- **CSRF Protection**: Disabled for API endpoints (session-based auth currently used)

## Security Features

### Password Security
- **BCrypt Hashing**: All passwords are hashed using BCrypt with has_secure_password
- **Minimum Length**: 6 character minimum password requirement
- **Confirmation**: Password confirmation required during signup

### Session Security
- **Session Fixation Protection**: Session tokens regenerated on login
- **Secure Logout**: Proper session cleanup on logout
- **Remember Location**: Users redirected to intended page after login

### Brute Force Protection
- **Rate Limiting**: Maximum 5 failed login attempts per session
- **Cooldown Period**: 15-minute lockout after exceeding failed attempts
- **Attempt Tracking**: Failed login attempts tracked in session

### Security Headers
All responses include comprehensive security headers:
- `X-Frame-Options: DENY` - Prevents clickjacking attacks
- `X-Content-Type-Options: nosniff` - Prevents MIME type sniffing
- `X-XSS-Protection: 1; mode=block` - Enables XSS filtering
- `Referrer-Policy: strict-origin-when-cross-origin` - Controls referrer information

### CSRF Protection
- **Token Validation**: All form submissions protected with CSRF tokens
- **Exception Handling**: Proper error handling for invalid tokens
- **API Exemption**: API endpoints skip CSRF (using session-based auth)

## Data Protection

### User Isolation
- **Scoped Queries**: All data queries scoped to current_user
- **Authorization Checks**: Users can only access their own data
- **Resource Protection**: Before filters ensure proper user ownership

### Input Validation
- **Model Validations**: Comprehensive validations on all user inputs
- **SQL Injection Prevention**: ActiveRecord ORM prevents SQL injection
- **Parameter Filtering**: Strong parameters prevent mass assignment

## Access Control Summary

| Route Pattern | Authentication Required | Additional Protection |
|---------------|------------------------|----------------------|
| `/` | No | Redirects authenticated users |
| `/login`, `/signup` | No | Redirects authenticated users |
| `/dashboard` | Yes | User-scoped data |
| `/categories/*` | Yes | User-scoped resources |
| `/transactions/*` | Yes | User-scoped resources |
| `/budgets/*` | Yes | User-scoped resources |
| `/users/:id/*` | Yes | Correct user validation |
| `/api/v1/*` | Yes | JSON error responses |

## Testing Security

### Manual Testing Commands
```bash
# Test public access (should return 200)
curl -I http://localhost:3000/

# Test protected routes (should return 302 redirect)
curl -I http://localhost:3000/dashboard
curl -I http://localhost:3000/categories

# Test API protection (should return 401)
curl -I http://localhost:3000/api/v1/dashboard/stats

# Verify security headers
curl -I http://localhost:3000/ | grep -E "(x-frame|x-content|x-xss|referrer)"
```

## Security Best Practices Implemented

1. **Defense in Depth**: Multiple layers of security (authentication, authorization, headers)
2. **Fail Secure**: Default deny approach - everything requires authentication unless explicitly public
3. **Least Privilege**: Users can only access their own data
4. **Input Validation**: All user inputs validated and sanitized
5. **Session Management**: Secure session handling with protection against fixation
6. **Error Handling**: Security-conscious error messages that don't leak information
7. **Modern Security Headers**: Comprehensive browser security protections

## Future Security Enhancements

- [ ] Implement API token authentication for better API security
- [ ] Add two-factor authentication (2FA) support
- [ ] Implement account lockout after multiple failed attempts
- [ ] Add audit logging for sensitive operations
- [ ] Implement Content Security Policy (CSP) headers
- [ ] Add rate limiting middleware for API endpoints
- [ ] Implement password strength requirements and breach checking 