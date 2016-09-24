# Rails Issue - 26545

This repo highlights the problem I'm encountering for issue https://github.com/rails/rails/issues/26545

The problem is from a default scope with `distinct` in it, when preloading is done. The fix is:

```
# START FIX
if preload_values[:distinct] || values[:distinct]
  scope.distinct!
end
# END FIX
```

All of the reproduction code is in `spec/problem_spec.rb`

1. `bundle install`
2. `rake db:setup`
3. `rspec`
