# System Monitoring Tools

This feature installs comprehensive system monitoring and performance analysis tools to help you understand and optimize your development environment.

## Usage

```json
"features": {
    "ghcr.io/eviljoshspicer-features/monitoring-tools:1": {
        "installHtop": true,
        "installBtop": true,
        "installGlances": true,
        "installNettools": true,
        "installIotools": true,
        "installCurl": true,
        "installStress": false,
        "installJq": true
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `installHtop` | boolean | `true` | Install htop process viewer |
| `installBtop` | boolean | `true` | Install btop++ modern resource monitor |
| `installGlances` | boolean | `true` | Install Glances cross-platform system monitor |
| `installNettools` | boolean | `true` | Install network monitoring tools |
| `installIotools` | boolean | `true` | Install I/O monitoring tools |
| `installCurl` | boolean | `true` | Install curl and wget for network testing |
| `installStress` | boolean | `false` | Install stress testing tools |
| `installJq` | boolean | `true` | Install jq JSON processor |

## Installed Monitoring Tools

### Process & Resource Monitors
- **htop** - Interactive process viewer with color and mouse support
- **btop++** - Modern C++ resource monitor with beautiful interface
- **glances** - Cross-platform system monitoring with web interface
- **top** - Classic process monitor (system default)

### Network Tools
- **ss** - Modern socket statistics utility
- **netstat** - Network connection statistics
- **nmap** - Network discovery and security auditing
- **traceroute** - Network path tracing
- **dnsutils** - DNS lookup utilities (dig, nslookup)

### I/O & Performance Tools  
- **iotop** - I/O usage monitor by process
- **iostat** - I/O statistics for devices and partitions
- **sysstat** - System performance monitoring utilities

### Network Testing
- **curl** - Command-line data transfer tool
- **wget** - File download utility  

### Stress Testing (Optional)
- **stress** - Simple stress testing tool
- **stress-ng** - Advanced stress testing with multiple workloads

### Utility Tools
- **jq** - Command-line JSON processor

## System Monitor Command (`sysmon`)

The feature includes a comprehensive `sysmon` command for quick system analysis:

```bash
# Quick system overview
sysmon overview
sysmon status

# Detailed component analysis  
sysmon cpu        # CPU information and usage
sysmon memory     # Memory usage and breakdown
sysmon disk       # Disk usage and devices
sysmon network    # Network interfaces and connections
sysmon processes  # Running processes

# Interactive monitoring
sysmon top        # Launch best available process monitor
sysmon logs       # Recent system logs
sysmon ports      # Open ports and services
```

## Interactive Monitors

### Launch Interactive Tools
```bash
htop              # Colorful process monitor
btop              # Modern resource monitor  
glances           # Comprehensive system monitor
iotop             # I/O usage by process
```

### Process Monitoring
```bash
# View processes by CPU usage
ps aux --sort=-%cpu | head -10

# View processes by memory usage  
ps aux --sort=-%mem | head -10

# Monitor specific process
watch -n 1 'ps aux | grep nginx'
```

## Network Monitoring

### Connection Analysis
```bash
# Active connections
ss -tuln                    # Modern approach
netstat -tuln              # Classic approach

# Monitor network traffic
ss -i                       # Interface statistics
watch -n 1 'ss -s'         # Connection summary

# Port scanning
nmap localhost              # Scan local ports
nmap -p 1-1000 hostname    # Scan specific port range
```

### Connectivity Testing
```bash
# HTTP requests
curl -I https://google.com          # Headers only
curl -w "%{time_total}\n" -o /dev/null https://api.github.com

# Network latency
ping -c 5 google.com
traceroute google.com

# DNS resolution
dig google.com
nslookup google.com
```

## Performance Analysis

### CPU Monitoring
```bash
# CPU usage over time
watch -n 1 'grep "cpu " /proc/stat'

# Load average
uptime
cat /proc/loadavg

# CPU information
lscpu
cat /proc/cpuinfo
```

### Memory Analysis
```bash
# Memory usage
free -h                     # Human readable
watch -n 1 'free -h'       # Continuous monitoring

# Memory by process
ps aux --sort=-%mem | head -10

# Memory mapping
cat /proc/meminfo
```

### Disk I/O
```bash
# Disk usage
df -h                       # Filesystem usage
du -sh /*                   # Directory sizes

# I/O statistics
iostat -x 1                 # Extended I/O stats
iotop                       # I/O by process

# Disk activity
watch -n 1 'cat /proc/diskstats'
```

## Stress Testing (Optional)

When stress testing tools are installed:

```bash
# CPU stress test
stress --cpu 4 --timeout 60s

# Memory stress test  
stress --vm 2 --vm-bytes 128M --timeout 60s

# Advanced stress testing
stress-ng --cpu 4 --io 2 --vm 1 --vm-bytes 1G --timeout 60s
```

## JSON Processing with jq

```bash
# API responses
curl -s https://api.github.com/users/octocat | jq '.'
curl -s https://api.github.com/users/octocat | jq '.name'

# Log analysis
cat app.log | jq '.level'
cat app.log | jq 'select(.level == "error")'

# System information
docker inspect container | jq '.[0].State'
```

## System Health Dashboard

Create custom monitoring scripts:

```bash
#!/bin/bash
# System health check
echo "=== System Health Report ==="
echo "Date: $(date)"
echo ""

echo "🖥️  System Load:"
uptime

echo ""
echo "💾 Memory Usage:"
free -h | grep Mem

echo ""  
echo "💿 Disk Usage:"
df -h | grep -E '^/dev'

echo ""
echo "🌐 Network:"
ss -s
```

## Pro Tips

1. **Create aliases** for frequently used commands:
   ```bash
   alias meminfo='free -h && echo && ps aux --sort=-%mem | head -10'
   alias netinfo='ss -tuln | head -20'
   ```

2. **Use watch** for continuous monitoring:
   ```bash
   watch -n 5 'sysmon overview'
   ```

3. **Combine tools** for comprehensive analysis:
   ```bash
   htop & iotop & wait
   ```

4. **Log monitoring** for debugging:
   ```bash
   tail -f /var/log/syslog | grep error
   ```

Run `monitor-info` to see all installed tools and get usage examples!