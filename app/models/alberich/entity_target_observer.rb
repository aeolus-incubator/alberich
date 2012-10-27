module Alberich
  class EntityTargetObserver < ActiveRecord::Observer
    observe Alberich.user_class.downcase.to_sym,  Alberich.user_group_class.downcase.to_sym

    def after_save(obj)
      entity = Entity.self.find_or_create_for_target(obj)
      entity.name = obj.to_s
      entity.save!
    end
  end
end
