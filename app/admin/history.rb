ActiveAdmin.register PaperTrail::Version, as: 'versions' do

  menu label: "Izmaiņu vēsture", parent: "Administrācija"
  actions :index, :show

  index title: "Izmaiņu vēsture" do 
    column "Resursa tips", sortable: :item_type do |v| I18n.t(v.item_type.downcase) end
    column "Resurss", sortable: :item_id do |v| link_to v.item_type.constantize.find(v.item_id).name, {controller: "admin/#{v.item_type.underscore.pluralize}", action: :show, id: v.item_id} end
    column "Notikums", sortable: :event do |v| I18n.t(v.event) end
    column "Versija izveidota", :created_at, sortable: :created_at
    # column :object_changes
    actions
  end

  show title: "Izmaiņu vēsture" do
    version = PaperTrail::Version.find(params[:id])
  	columns do
      column do
        panel 'Versijas informācija' do
          attributes_table_for version do
            row "Resursa tips" do |v| I18n.t(v.item_type.downcase) end
            row "Resursa id" do |v| v.item_id end
            row "Notikums" do |v| I18n.t(v.event) end
            row "Izveidots" do |v| v.created_at end
          end
        end
      end
      column span: 3 do
        panel 'Objekts' do
          div class: 'text_display' do 
            if version.object.blank?
              li "---"
            else arr = version.object.split(/(\w*:[^\d])/).each {|n| n.gsub!(/\n/, " ")};
              arr.delete_at(0);
              arr.chunk(2).each do |x|
                li x
              end
            end
          end
        end
        panel 'Objekta izmaiņas' do
          div class: 'text_display' do 
            version_changeset_refiner(version).each do |key,val|
              li "#{key.humanize}: #{val.join(' => ')}"
            end
          end
        end
      end
    end
  end

end

class Array

  def chunk(sizen=2, chunks=[])
    (0...self.length).step(sizen) { |n| chunks << self[n,sizen] }
    return chunks
  end

end
