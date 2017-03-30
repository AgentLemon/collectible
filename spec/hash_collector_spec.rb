require "spec_helper"

describe Collectible::HashCollector do
  describe "simple collection" do
    let!(:schema) do
      Collectible::Schema.new(
        :user,
        :id,
        id: "user_id",
        name: "name",
        posts: Collectible::Schema.new(
          :post,
          :id,
          id: "post_id",
          text: "post_text"
        )
      )
    end

    it "parses simple collection" do
      data = load_collection("simple_collection")
      result = Collectible::HashCollector.new(schema).collect(data)

      expect(result).to eq([
        { id: "1", name: "Ivan", posts: [{ id: "1", text: "hello" }] },
        { id: "2", name: "Simeon", posts: [{ id: "2", text: "hi" }, { id: "3", text: "how are you?" }] }
      ])
    end

    it "doesn't create records with empty ids" do
      data = load_collection("simple_collection_empty_ids")
      result = Collectible::HashCollector.new(schema).collect(data)

      expect(result).to eq([
        { id: "1", name: "Ivan", posts: [] },
        { id: "2", name: "Simeon", posts: [
          { id: "2", text: "hi" },
          { id: "3", text: "how are you?" }
        ]}
      ])
    end
  end

  describe "2 children collection" do
    let!(:schema) do
      Collectible::Schema.new(
        :user,
        :id,
        id: "user_id",
        name: "name",
        posts: Collectible::Schema.new(
          :post,
          :id,
          id: "post_id",
          text: "post_text",
          attachments: Collectible::Schema.new(
            :attachment,
            :id,
            id: "attachment_id",
            filename: "filename"
          )
        )
      )
    end
    
    it "parses 2 children collection" do
      data = load_collection("2_children_collection")
      result = Collectible::HashCollector.new(schema).collect(data)

      expect(result).to eq([
        { id: "1", name: "Ivan", posts: [{ id: "1", text: "hello", attachments: [] }] },
        { id: "2", name: "Simeon", posts: [
          { id: "2", text: "hi", attachments: [
            { id: "1", filename: "1.png" },
            { id: "2", filename: "2.png" }
          ]},
          { id: "3", text: "how are you?", :attachments => [] }]
        }
      ])
    end

    it "parses shared children collection" do
      data = load_collection("shared_children_collection")
      result = Collectible::HashCollector.new(schema).collect(data)

      expect(result).to eq([
        {
          id: "1",
          name: "Ivan",
          posts: [
            { id: "1", text: "hello", attachments: [
              { id: "3", filename: "3.png" }
            ]},
            { id: "2",
              text: "hi",
              attachments: [
                { id: "1", filename: "1.png" },
                { id: "2", filename: "2.png" }
              ]
            }
          ]
        },
        {
          id: "2",
          name: "Simeon",
          posts: [
            {
              id:"2",
              text: "hi",
              attachments: [ { id: "1", filename: "1.png" }, { id: "2", filename: "2.png" } ]
            },
            {
              id: "3",
              text: "how are you?",
              attachments: []
            },
            {
              id: "1",
              text: "hello",
              attachments: [ { id: "3", filename: "3.png" } ]
            }
          ]
        }
      ])
    end
  end
end
