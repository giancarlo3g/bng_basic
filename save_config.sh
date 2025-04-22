#!/bin/bash

# SROS devices
yes | cp ./clab-bng/bng1/tftpboot/config.txt ./config/bng1.cfg
yes | cp ./clab-bng/bng2/tftpboot/config.txt ./config/bng2.cfg
yes | cp ./clab-bng/agg1/tftpboot/config.txt ./config/agg1.cfg
yes | cp ./clab-bng/olt1/tftpboot/config.txt ./config/olt1.cfg
# SRL devices
yes | cp ./clab-bng/ont1/config/config.json ./config/ont1.json
yes | cp ./clab-bng/switch/config/config.json ./config/switch.json
yes | scp ont1:/home/admin/config.cfg ./config/ont1.cfg
yes | scp switch:/home/admin/config.cfg ./config/switch.cfg
