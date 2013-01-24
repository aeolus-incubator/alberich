module Alberich
  class EntityTargetObserver < ActiveRecord::Observer
    observe Alberich.user_class.underscore.to_sym,  Alberich.user_group_class.underscore.to_sym

    def after_save(obj)
      entity = Entity.find_or_create_for_target(obj)
      entity.name = obj.to_s
      entity.save!
    end

    def after_destroy(obj)
      entity = Entity.for_target(obj)
      entity.destroy if entity
    end
  end
end
