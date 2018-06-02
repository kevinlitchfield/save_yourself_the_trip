require "save_yourself_the_trip/version"
require 'active_record'

module SaveYourselfTheTrip
  @@on = false
  def self.on?; @@on == true; end
  def self.on!; @@on = true; end
  def self.off!; @@on = false; end

  @@warn_level = :error
  def self.warn!; @@warn_level = :warn; end
  def self.error!; @@warn_level = :error; end
  def self.error?; @@warn_level == :error; end

  class ExtraTripError < StandardError; end
end

module SaveYourselfTheTrip::ActiveRecord
  attr_accessor :save_yourself_the_trip__referrer

  def self.prepended(base)
    base.reflect_on_all_associations.each do |association|
      if association.class.name.demodulize == 'BelongsToReflection'
        define_method(association.name) do
          object_looked_up = super()
          object_looked_up.save_yourself_the_trip__referrer = association
          object_looked_up
        end
      end
    end

    define_method(base.primary_key) do
      if SaveYourselfTheTrip.on? && save_yourself_the_trip__referrer.name.to_s.camelize.constantize == self.class
        message = "You called `<#{save_yourself_the_trip__referrer.active_record.to_s}>.#{save_yourself_the_trip__referrer.name.to_s}.#{base.primary_key}`. Better to call `<#{save_yourself_the_trip__referrer.active_record.to_s}>.#{save_yourself_the_trip__referrer.foreign_key}` and save yourself an extra trip to the database."
        if SaveYourselfTheTrip.error?
          raise SaveYourselfTheTrip::ExtraTripError, message
        else
          puts "*** EXTRA QUERY DETECTED: #{message} ***"
        end
      end

      super()
    end
  end
end

ActiveRecord::Base.descendants.each do |descendant|
  descendant.prepend(SaveYourselfTheTrip::ActiveRecord)
end
