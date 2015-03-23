module Skroutz::UrlHelpers
  def base_path
    return "#{owner.resource_prefix}/#{owner.id}/#{resource_prefix}" if owner

    resource_prefix
  end
end
