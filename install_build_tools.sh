#!/bin/bash

curl -sSL https://get.rvm.io | bash

export PATH=$HOME/.rvm/bin:$PATH
rvm install ruby-2.1-head
gem install sass
gem install compass

