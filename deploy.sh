#!/bin/bash
rsync -checksum -av -e "ssh -i ~/Documents/resources/cobol-game/handson-key-ikarimoto.pem" --exclude '.git' ./ ec2-user@ec2-13-231-238-35.ap-northeast-1.compute.amazonaws.com:~/cobol-game/