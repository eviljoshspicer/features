#!/bin/sh
set -e

echo "Activating feature 'monitoring-tools'"

# Update package lists
apt-get update

# Install htop if enabled
if [ "${INSTALLHTOP}" = "true" ]; then
    echo "Installing htop..."
    apt-get install -y htop
fi

# Install btop if enabled
if [ "${INSTALLBTOP}" = "true" ]; then
    echo "Installing btop++..."
    
    # btop++ might not be in all repositories, so we'll try different approaches
    if apt-cache search btop | grep -q "btop"; then
        apt-get install -y btop
    else
        # Install from snap if available
        if command -v snap > /dev/null 2>&1; then
            snap install btop
        else
            echo "btop++ not available in repositories, skipping..."
        fi
    fi
fi

# Install Glances if enabled
if [ "${INSTALLGLANCES}" = "true" ]; then
    echo "Installing Glances..."
    apt-get install -y python3-pip
    pip3 install glances
fi

# Install network tools if enabled
if [ "${INSTALLNETTOOLS}" = "true" ]; then
    echo "Installing network tools..."
    apt-get install -y net-tools iproute2 dnsutils traceroute nmap
fi

# Install I/O tools if enabled
if [ "${INSTALLIOTOOLS}" = "true" ]; then
    echo "Installing I/O monitoring tools..."
    apt-get install -y iotop sysstat
fi

# Install curl and wget if enabled
if [ "${INSTALLCURL}" = "true" ]; then
    echo "Installing curl and wget..."
    apt-get install -y curl wget
fi

# Install stress testing tools if enabled
if [ "${INSTALLSTRESS}" = "true" ]; then
    echo "Installing stress testing tools..."
    apt-get install -y stress stress-ng
fi

# Install jq if enabled
if [ "${INSTALLJQ}" = "true" ]; then
    echo "Installing jq..."
    apt-get install -y jq
fi

# Create system monitoring helper script
cat > /usr/local/bin/sysmon << 'EOF'
#!/bin/bash
# System monitoring helper script

show_help() {
    echo "System Monitoring Helper"
    echo "======================="
    echo ""
    echo "Usage: sysmon [command]"
    echo ""
    echo "Available commands:"
    echo "  overview, status  - Show system overview"
    echo "  cpu              - Show CPU information and usage"
    echo "  memory, mem      - Show memory usage"
    echo "  disk             - Show disk usage"
    echo "  network, net     - Show network information"
    echo "  processes, ps    - Show running processes"
    echo "  top              - Launch interactive process monitor"
    echo "  logs             - Show recent system logs"
    echo "  ports            - Show open ports"
    echo ""
    echo "Examples:"
    echo "  sysmon overview  - Quick system overview"
    echo "  sysmon cpu       - Detailed CPU information"
    echo "  sysmon top       - Interactive process monitor"
}

show_overview() {
    echo "🖥️  System Overview"
    echo "=================="
    echo ""
    
    # System info
    echo "📋 System Information:"
    echo "  OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")"
    echo "  Kernel: $(uname -r)"
    echo "  Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo ""
    
    # CPU info
    echo "🔧 CPU:"
    if [ -f /proc/cpuinfo ]; then
        cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
        cpu_count=$(grep -c "processor" /proc/cpuinfo)
        echo "  Model: $cpu_model"
        echo "  Cores: $cpu_count"
    fi
    
    # Load average
    if [ -f /proc/loadavg ]; then
        load=$(cat /proc/loadavg | cut -d' ' -f1-3)
        echo "  Load: $load"
    fi
    echo ""
    
    # Memory info
    echo "💾 Memory:"
    if command -v free > /dev/null 2>&1; then
        free -h | grep -E "Mem|Swap"
    fi
    echo ""
    
    # Disk info
    echo "💿 Disk Usage:"
    df -h | grep -E "^/dev|^tmpfs" | head -5
    echo ""
    
    # Network info
    echo "🌐 Network:"
    if command -v ip > /dev/null 2>&1; then
        ip addr show | grep -E "inet " | grep -v "127.0.0.1" | head -3
    fi
}

show_cpu() {
    echo "🔧 CPU Information"
    echo "=================="
    echo ""
    
    if [ -f /proc/cpuinfo ]; then
        echo "📋 CPU Details:"
        grep -E "model name|cpu cores|siblings|cpu MHz" /proc/cpuinfo | head -4
        echo ""
    fi
    
    echo "📊 Current Usage:"
    if command -v top > /dev/null 2>&1; then
        top -bn1 | grep "Cpu(s)" || echo "CPU usage data not available"
    fi
    
    if [ -f /proc/loadavg ]; then
        echo "Load Average: $(cat /proc/loadavg)"
    fi
}

show_memory() {
    echo "💾 Memory Information"
    echo "===================="
    echo ""
    
    if command -v free > /dev/null 2>&1; then
        free -h
        echo ""
        
        # Memory breakdown
        echo "📊 Memory Breakdown:"
        free | awk 'NR==2{printf "  Used: %.1f%% (%s/%s)\n", $3*100/$2, $3, $2}'
        
        # Top memory processes
        echo ""
        echo "🔝 Top Memory Processes:"
        ps aux --sort=-%mem | head -6
    fi
}

show_disk() {
    echo "💿 Disk Information"
    echo "=================="
    echo ""
    
    echo "📊 Disk Usage:"
    df -h
    echo ""
    
    if command -v lsblk > /dev/null 2>&1; then
        echo "🔧 Block Devices:"
        lsblk
    fi
}

show_network() {
    echo "🌐 Network Information"
    echo "====================="
    echo ""
    
    echo "📡 Network Interfaces:"
    if command -v ip > /dev/null 2>&1; then
        ip addr show
    elif command -v ifconfig > /dev/null 2>&1; then
        ifconfig
    fi
    
    echo ""
    echo "🔗 Active Connections:"
    if command -v ss > /dev/null 2>&1; then
        ss -tuln | head -10
    elif command -v netstat > /dev/null 2>&1; then
        netstat -tuln | head -10
    fi
}

show_processes() {
    echo "⚙️  Process Information"
    echo "======================"
    echo ""
    
    echo "🔝 Top CPU Processes:"
    ps aux --sort=-%cpu | head -6
    echo ""
    
    echo "🔝 Top Memory Processes:"
    ps aux --sort=-%mem | head -6
}

launch_top() {
    echo "Launching interactive process monitor..."
    
    if command -v btop > /dev/null 2>&1; then
        btop
    elif command -v htop > /dev/null 2>&1; then
        htop
    elif command -v glances > /dev/null 2>&1; then
        glances
    elif command -v top > /dev/null 2>&1; then
        top
    else
        echo "No interactive process monitor available"
    fi
}

show_logs() {
    echo "📋 Recent System Logs"
    echo "===================="
    echo ""
    
    if command -v journalctl > /dev/null 2>&1; then
        journalctl -n 20 --no-pager
    elif [ -f /var/log/syslog ]; then
        tail -20 /var/log/syslog
    else
        echo "System logs not accessible"
    fi
}

show_ports() {
    echo "🔌 Open Ports"
    echo "============="
    echo ""
    
    if command -v ss > /dev/null 2>&1; then
        ss -tuln
    elif command -v netstat > /dev/null 2>&1; then
        netstat -tuln
    else
        echo "Network tools not available"
    fi
}

# Main command handling
case "${1:-overview}" in
    "help"|"-h"|"--help")
        show_help
        ;;
    "overview"|"status")
        show_overview
        ;;
    "cpu")
        show_cpu
        ;;
    "memory"|"mem")
        show_memory
        ;;
    "disk")
        show_disk
        ;;
    "network"|"net")
        show_network
        ;;
    "processes"|"ps")
        show_processes
        ;;
    "top")
        launch_top
        ;;
    "logs")
        show_logs
        ;;
    "ports")
        show_ports
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run 'sysmon help' for available commands"
        exit 1
        ;;
esac
EOF

chmod +x /usr/local/bin/sysmon

# Create monitoring info command
cat > /usr/local/bin/monitor-info << 'EOF'
#!/bin/sh
echo "📊 System Monitoring Tools"
echo "=========================="
echo ""

echo "🔧 Available Monitoring Tools:"
if command -v htop > /dev/null 2>&1; then
    echo "  ✅ htop - Interactive process viewer"
fi
if command -v btop > /dev/null 2>&1; then
    echo "  ✅ btop++ - Modern resource monitor"
fi
if command -v glances > /dev/null 2>&1; then
    echo "  ✅ glances - Cross-platform system monitor"
fi
if command -v iotop > /dev/null 2>&1; then
    echo "  ✅ iotop - I/O monitoring"
fi
if command -v iostat > /dev/null 2>&1; then
    echo "  ✅ iostat - I/O statistics"
fi

echo ""
echo "🌐 Network Tools:"
if command -v ss > /dev/null 2>&1; then
    echo "  ✅ ss - Socket statistics"
fi
if command -v netstat > /dev/null 2>&1; then
    echo "  ✅ netstat - Network statistics"
fi
if command -v nmap > /dev/null 2>&1; then
    echo "  ✅ nmap - Network mapper"
fi
if command -v curl > /dev/null 2>&1; then
    echo "  ✅ curl - Data transfer tool"
fi

echo ""
echo "⚡ Performance Tools:"
if command -v stress > /dev/null 2>&1; then
    echo "  ✅ stress - CPU/memory stress testing"
fi
if command -v stress-ng > /dev/null 2>&1; then
    echo "  ✅ stress-ng - Advanced stress testing"
fi

echo ""
echo "🛠️  Utility Tools:"
if command -v jq > /dev/null 2>&1; then
    echo "  ✅ jq - JSON processor"
fi

echo ""
echo "🎯 Quick Commands:"
echo "  sysmon         - System monitoring helper"
echo "  sysmon overview - Quick system overview"
echo "  sysmon top     - Launch best available process monitor"
echo "  htop           - Interactive process viewer"
echo "  glances        - System monitor"
echo "  iotop          - I/O monitor"

echo ""
echo "💡 Pro Tips:"
echo "  - Use 'sysmon overview' for a quick system health check"
echo "  - Run 'sysmon top' to launch the best available monitor"
echo "  - Use 'nmap localhost' to scan local open ports"
echo "  - Try 'curl -s httpbin.org/ip | jq' to test network and JSON parsing"
EOF

chmod +x /usr/local/bin/monitor-info

echo "System monitoring tools installed! Run 'monitor-info' for details."