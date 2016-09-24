require "rails_helper"

module FixDistinct
  def build_scope
    scope = klass.unscoped
    values         = reflection_scope.values
    reflection_binds = reflection_scope.bind_values
    preload_values = preload_scope.values
    preload_binds  = preload_scope.bind_values

    scope.where_values      = Array(values[:where])      + Array(preload_values[:where])
    scope.references_values = Array(values[:references]) + Array(preload_values[:references])
    scope.bind_values       = (reflection_binds + preload_binds)

    scope._select!   preload_values[:select] || values[:select] || table[Arel.star]
    scope.includes! preload_values[:includes] || values[:includes]
    scope.joins! preload_values[:joins] || values[:joins]
    scope.order! preload_values[:order] || values[:order]

    if preload_values[:reordering] || values[:reordering]
      scope.reordering_value = true
    end

    if preload_values[:readonly] || values[:readonly]
      scope.readonly!
    end

    # START FIX
    if preload_values[:distinct] || values[:distinct]
      scope.distinct!
    end
    # END FIX

    if options[:as]
      scope.where!(klass.table_name => { reflection.type => model.base_class.sti_name })
    end

    scope.unscope_values = Array(values[:unscope]) + Array(preload_values[:unscope])
    klass.default_scoped.merge(scope)
  end
end

RSpec.describe "Issue 26545" do
  it "has duplicates without a patch" do
    c = C.create!
    a = A.create!(c: c)
    a2 = A.create!(c: c)
    b = B.create!(a: a, c: c)
    b2 = B.create!(a: a2, c: c)
    b3 = B.create!(a: a2, c: c)

    preloaded_a = c.as.includes(bs: { c: [:as] })
    ids = preloaded_a.first.bs.first.c.as.map(&:id)
    expect(ids).to eq([a.id, a2.id, a2.id]) # a2 is duplicate, but there is a distinct on the default scope!
  end

  it "doesn't have duplicates with a patch" do
    ActiveRecord::Associations::Preloader::Association.prepend(FixDistinct)
    c = C.create!
    a = A.create!(c: c)
    a2 = A.create!(c: c)
    b = B.create!(a: a, c: c)
    b2 = B.create!(a: a2, c: c)
    b3 = B.create!(a: a2, c: c)

    preloaded_a = c.as.includes(bs: { c: [:as] })
    ids = preloaded_a.first.bs.first.c.as.map(&:id)
    expect(ids).to eq([a.id, a2.id])
  end
end
