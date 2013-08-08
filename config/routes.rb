Prox::Application.routes.draw do
  get ':controller(/:action(/:id))',:id => /[^\/]*/#(.:format)
end
