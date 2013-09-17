#bind 'tcp://127.0.0.1:3000'
bind 'tcp://0.0.0.0:1346'
pidfile "/var/rails/prox/tmp/puma/pid"
state_path "/var/rails/prox/tmp/puma/state"

quiet

threads 0, 100

environment "production"


activate_control_app
