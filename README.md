# fluxus2

A new Flutter project.

## Getting Started

catalunha@pop-os:~$ flutter create --project-name=fluxus2 --org br.net.cemec --platforms android,web ./fluxus2

catalunha@pop-os:~/myapp/cemec.net.br/fluxus2/back4app/fluxus2$ ln -s /home/catalunha/myapp/cemec.net.br/fluxus2/build/web public

cd ~/myapp/cemec.net.br/fluxus2 && flutter build web && cd back4app/fluxus2/ && b4a deploy

find . -type f -name "*.dart" | xargs -r rename "s/graduation/office/g"