module ActiveAdmin
  module Comments
    module Views
      class Comments < ActiveAdmin::Views::Panel
        def build_comment(comment)
          div :for => comment do
            div :class => "active_admin_comment_meta" do
              user_name = comment.author ? auto_link(comment.author) : "Anonymous"
              h4(user_name, :class => "active_admin_comment_author")
              a '', '#', name: "comment_#{comment.id}"
              span(pretty_format(comment.created_at))
            end
            div :class => "active_admin_comment_body" do
              simple_format(comment.body)
            end
            div :style => "clear:both;"
            if authorized?(ActiveAdmin::Auth::DESTROY, comment)
              text_node (link_to "#{I18n.t('active_admin.comments.delete')}", comments_url(comment.id), method: :delete, data: { confirm: I18n.t('active_admin.comments.delete_confirmation') })<<" | "
            end
            if authorized?(ActiveAdmin::Auth::UPDATE, comment)
              text_node link_to I18n.t('active_admin.comments.edit'), "/admin/active_admin_comments/#{comment.id}/edit"
            end
          end
        end
      end
    end
  end
end
