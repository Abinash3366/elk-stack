# Setup scripts for new edge servers to sync logs and other metrics to ELK stack

## Usage
Runs on any system that uses `apt-get`.
```
wget "https://raw.githubusercontent.com/shaunakg/elk-stack/main/setup.sh"
sudo sh setup.sh
```

## Overview
- Current server hostname: `k.odin.srg.id.au`
- [Kibana dashboard](http://k.odin.srg.id.au) (Internal)
    - [Inventory view](http://k.odin.srg.id.au/app/metrics/inventory)
