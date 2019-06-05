json.set! :data do
  json.array! @admin_marketing_campaigns do |admin_marketing_campaign|
    json.partial! 'admin_marketing_campaigns/admin_marketing_campaign', admin_marketing_campaign: admin_marketing_campaign
    json.url  "
              #{link_to 'Show', admin_marketing_campaign }
              #{link_to 'Edit', edit_admin_marketing_campaign_path(admin_marketing_campaign)}
              #{link_to 'Destroy', admin_marketing_campaign, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end