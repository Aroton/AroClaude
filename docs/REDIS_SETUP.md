# Redis MCP Server Setup

This guide explains how to set up the Redis MCP server for efficient context storage in AroClaude agents.

## Overview

Redis-based context storage provides several advantages over file-based storage:
- **Preserves Plan Mode**: No file writes that exit plan mode
- **Performance**: Faster in-memory context access
- **Automatic Cleanup**: TTL-based expiration of old context
- **Clean Architecture**: No temporary files in the repository

## Prerequisites

- Redis server (local or remote)
- **For Official Redis MCP**: Python 3.8+ and uv package manager
- **For NPM Alternative**: Node.js 18+ and npm
- Claude Code v1.0+ with MCP support

## Installation Steps

### 1. Install Redis Server

#### macOS (using Homebrew)
```bash
brew install redis
brew services start redis
```

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

#### Windows (using WSL or Docker)
```bash
# Using Docker
docker run -d --name redis -p 6379:6379 redis:latest

# Or install in WSL following Ubuntu instructions
```

### 2. Install Redis MCP Server

#### Option A: Official Redis MCP Server (Recommended)
```bash
# Install using uvx (requires Python and uv)
pip install uv
uvx --from git+https://github.com/redis/mcp-redis.git redis-mcp-server --url redis://localhost:6379/0
```

#### Option B: Alternative NPM Package
```bash
# Install community-maintained package
npm install -g @gongrzhe/server-redis-mcp@1.0.0
```

#### Option C: From Source (Development)
```bash
# Clone and build from source
git clone https://github.com/redis/mcp-redis.git
cd mcp-redis
pip install -e .
```

### 3. Configure Claude Code

Add the Redis MCP server to your Claude Code configuration:

#### Option A: Global Configuration (`~/.claude/settings.json`)

**For Official Redis MCP Server:**
```json
{
  "mcpServers": {
    "redis": {
      "command": "uvx",
      "args": [
        "--from", 
        "git+https://github.com/redis/mcp-redis.git", 
        "redis-mcp-server", 
        "--url", 
        "redis://localhost:6379/0"
      ]
    }
  }
}
```

**For NPM Package:**
```json
{
  "mcpServers": {
    "redis": {
      "command": "npx",
      "args": ["@gongrzhe/server-redis-mcp@1.0.0", "redis://localhost:6379"]
    }
  }
}
```

#### Option B: Project Configuration (`.claude/settings.local.json`)

Use the same configuration format as above, but place in your project's `.claude/settings.local.json` file.

### 4. Verify Installation

Test that the Redis MCP server is working:

```bash
# Start Claude Code in any project
claude

# In Claude Code, try a Redis operation
# If working, you'll see redis tools available in agent tool lists
```

## Redis Configuration

### Connection Settings

#### Local Redis (default)
```json
{
  "env": {
    "REDIS_URL": "redis://localhost:6379"
  }
}
```

#### Remote Redis
```json
{
  "env": {
    "REDIS_URL": "redis://username:password@hostname:port/database"
  }
}
```

#### Redis with Authentication
```json
{
  "env": {
    "REDIS_URL": "redis://:password@localhost:6379"
  }
}
```

### Context Storage Configuration

AroClaude agents use these Redis settings:
- **Key Pattern**: `claude:context:{agent-name}:{timestamp}`
- **TTL**: 24 hours (86400 seconds)
- **Database**: Default (0)

## Troubleshooting

### Redis Server Not Running
```bash
# Check Redis status
redis-cli ping
# Should return: PONG

# If not running, start Redis
# macOS: brew services start redis
# Ubuntu: sudo systemctl start redis-server
```

### MCP Server Issues
```bash
# Test official Redis MCP server directly
uvx --from git+https://github.com/redis/mcp-redis.git redis-mcp-server --url redis://localhost:6379/0

# Test NPM package directly
npx @gongrzhe/server-redis-mcp@1.0.0 redis://localhost:6379

# Check Claude Code logs
claude --verbose
```

### Connection Issues
1. Verify Redis URL in configuration
2. Check firewall settings for port 6379
3. Ensure Redis accepts connections from your IP
4. Test with `redis-cli -h hostname -p port`

### Common 2025 Issues

#### Server Disconnection Problems
```bash
# Check Redis server stability
redis-cli --latency-history -i 1

# Monitor connection health
redis-cli monitor
```

#### Windows Compatibility Issues
- Use WSL2 for best compatibility
- Ensure uvx is properly installed in WSL environment
- Consider Docker alternative:
```bash
docker run -d --name redis-mcp -p 6379:6379 redis:7-alpine
```

#### Package Version Conflicts
```bash
# Clear npm cache if using NPM option
npm cache clean --force

# Reinstall with specific version
npm install -g @gongrzhe/server-redis-mcp@1.0.0 --force
```

### Fallback Behavior

If Redis is unavailable, AroClaude agents automatically fall back to:
- Returning context directly in responses
- No file-based storage (maintains plan mode)
- Full functionality with slightly larger token usage

## Benefits Over File-Based Storage

| Aspect | File Storage | Redis Storage |
|--------|-------------|---------------|
| Plan Mode | Exits on Write | Preserved |
| Performance | Disk I/O | Memory access |
| Cleanup | Manual/gitignore | Automatic TTL |
| Persistence | Files remain | Auto-expires |
| Token Usage | Minimal | Minimal |
| Setup | None | One-time setup |

## Security Considerations

### 2025 Security Updates
- **CVE-2023-45145**: Update Redis to 7.2.4+ or 6.2.14+
- **Authentication Required**: Always use AUTH for production instances
- **Network Security**: Bind Redis to specific interfaces only
- **TLS Encryption**: Required for remote connections

### Configuration Security
```bash
# Redis security configuration
requirepass your_strong_password
bind 127.0.0.1 ::1
port 0  # Disable non-TLS port
tls-port 6380
tls-cert-file /path/to/cert.crt
tls-key-file /path/to/private.key
```

### Memory and Resource Limits
```bash
# Set memory limits
maxmemory 256mb
maxmemory-policy allkeys-lru

# Connection limits
maxclients 100
timeout 300
```

### Monitoring and Logging
- Enable Redis slow query log
- Monitor memory usage with `redis-cli info memory`
- Set up alerts for connection spikes
- Regularly audit Redis commands via logs

## Verification and Testing

### 1. Verify Installation
```bash
# Test Redis connection
redis-cli ping
# Expected: PONG

# Test MCP server (choose your installation method)
# Official server:
uvx --from git+https://github.com/redis/mcp-redis.git redis-mcp-server --url redis://localhost:6379/0

# NPM alternative:
npx @gongrzhe/server-redis-mcp@1.0.0 redis://localhost:6379
```

### 2. Claude Code Integration Test
1. Restart Claude Code to load the MCP server
2. Verify agent tool lists include `mcp__redis__*` tools
3. Test basic Redis operations:
   ```
   # In Claude Code, try:
   SET test_key "hello world"
   GET test_key
   ```

### 3. AroClaude Agent Testing
1. Test context-passing between research agents
2. Verify context storage with TTL
3. Monitor Redis memory usage: `redis-cli info memory`
4. Check context keys: `redis-cli keys "claude:context:*"`

## Migration from Old Setup

If you previously used incorrect package names:

```bash
# Remove old packages
npm uninstall -g @anthropic/mcp-server-redis 2>/dev/null || true
npm uninstall -g @modelcontextprotocol/server-redis 2>/dev/null || true

# Install correct package
npm install -g @gongrzhe/server-redis-mcp@1.0.0

# Or use official Python version
pip install uv
```

Then update your Claude Code configuration files with the corrected settings shown above.