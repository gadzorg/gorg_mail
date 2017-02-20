class OccurenciesValidator < ActiveModel::EachValidator

  def check_validity!

  end

  def validate_each(record, attribute, value)
    klass=record.class

    if options[:max]
      if watched_value?(value)
        occ=klass.where(scope_query(record)).where(attribute => value).count
        if occ>=options[:max]
          record.errors.add(attribute, :too_many, message: "is already used #{occ} times (max: #{options[:max]})")
        end
      end
    end

    if options[:min]
      if watched_value?(record.changed_attributes[attribute])
        occ=klass.where(scope_query(record)).where(attribute => value).count
        if occ<=options[:min]
          record.errors.add(attribute, :too_many, message: "is only used #{occ} times (min: #{options[:min]})")
        end
      end
    end

  end

  private
  def watched_value?(val)
    !options[:only] || [*options[:only]].any?{|v| v==val}
  end

  def scope_query(record)
    [*options[:scope]].map{|s| [s,record.send(s)]}.to_h.merge(options[:where].to_h)
  end
end