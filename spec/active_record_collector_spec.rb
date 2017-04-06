require "spec_helper"
require "stubs/active_record_stub"

describe "active record collections" do
  describe "simple collection" do
    let!(:schema) do
      Collectible::Schema.new(
        ActiveRecordStub::User,
        :id,
        id: "user_id",
        name: "name",
        posts: Collectible::Schema.new(
          ActiveRecordStub::Post,
          :id,
          id: "post_id",
          text: "post_text"
        )
      )
    end

    it "parses simple collection" do
      data = load_collection("simple_collection")
      result = Collectible::ObjectCollector.new(schema).collect(data)

      expect(result.size).to eq(2)

      expect(result[0].id).to eq("1")
      expect(result[0].name).to eq("Ivan")
      expect(result[0].posts.size).to eq(1)
      expect(result[0].posts[0].id).to eq("1")
      expect(result[0].posts[0].text).to eq("hello")

      expect(result[1].id).to eq("2")
      expect(result[1].name).to eq("Simeon")
      expect(result[1].posts.size).to eq(2)
      expect(result[1].posts[0].id).to eq("2")
      expect(result[1].posts[0].text).to eq("hi")
      expect(result[1].posts[1].id).to eq("3")
      expect(result[1].posts[1].text).to eq("how are you?")
    end

    it "doesn't create records with empty ids" do
      data = load_collection("simple_collection_empty_ids")
      result = Collectible::ObjectCollector.new(schema).collect(data)

      expect(result.size).to eq(2)

      expect(result[0].id).to eq("1")
      expect(result[0].name).to eq("Ivan")
      expect(result[0].posts).to eq([])

      expect(result[1].id).to eq("2")
      expect(result[1].name).to eq("Simeon")
      expect(result[1].posts.size).to eq(2)
      expect(result[1].posts[0].id).to eq("2")
      expect(result[1].posts[0].text).to eq("hi")
      expect(result[1].posts[1].id).to eq("3")
      expect(result[1].posts[1].text).to eq("how are you?")
    end
  end

  describe "2 children collection" do
    let!(:schema) do
      Collectible::Schema.new(
        ActiveRecordStub::User,
        :id,
        id: "user_id",
        name: "name",
        posts: Collectible::Schema.new(
          ActiveRecordStub::Post,
          :id,
          id: "post_id",
          text: "post_text",
          attachments: Collectible::Schema.new(
            ActiveRecordStub::Attachment,
            :id,
            id: "attachment_id",
            filename: "filename"
          )
        )
      )
    end
    
    it "parses 2 children collection" do
      data = load_collection("2_children_collection")
      result = Collectible::ObjectCollector.new(schema).collect(data)

      expect(result.size).to eq(2)

      expect(result[0].id).to eq("1")
      expect(result[0].name).to eq("Ivan")
      expect(result[0].posts.size).to eq(1)
      expect(result[0].posts[0].id).to eq("1")
      expect(result[0].posts[0].text).to eq("hello")
      expect(result[0].posts[0].attachments).to eq([])

      expect(result[1].id).to eq("2")
      expect(result[1].name).to eq("Simeon")
      expect(result[1].posts.size).to eq(2)
      expect(result[1].posts[0].id).to eq("2")
      expect(result[1].posts[0].text).to eq("hi")
      expect(result[1].posts[0].attachments.size).to eq(2)
      expect(result[1].posts[0].attachments[0].id).to eq("1")
      expect(result[1].posts[0].attachments[0].filename).to eq("1.png")
      expect(result[1].posts[0].attachments[1].id).to eq("2")
      expect(result[1].posts[0].attachments[1].filename).to eq("2.png")

      expect(result[1].posts[1].id).to eq("3")
      expect(result[1].posts[1].text).to eq("how are you?")
      expect(result[1].posts[1].attachments).to eq([])
    end

    it "parses shared children collection" do
      data = load_collection("shared_children_collection")
      result = Collectible::ObjectCollector.new(schema).collect(data)

      expect(result.size).to eq(2)

      expect(result[0].id).to eq("1")
      expect(result[0].name).to eq("Ivan")
      expect(result[0].posts.size).to eq(2)
      expect(result[0].posts[0].id).to eq("1")
      expect(result[0].posts[0].text).to eq("hello")
      expect(result[0].posts[0].attachments.size).to eq(1)
      expect(result[0].posts[0].attachments[0].id).to eq("3")
      expect(result[0].posts[0].attachments[0].filename).to eq("3.png")
      expect(result[0].posts[1].id).to eq("2")
      expect(result[0].posts[1].text).to eq("hi")
      expect(result[0].posts[1].attachments.size).to eq(2)
      expect(result[0].posts[1].attachments[0].id).to eq("1")
      expect(result[0].posts[1].attachments[0].filename).to eq("1.png")
      expect(result[0].posts[1].attachments[1].id).to eq("2")
      expect(result[0].posts[1].attachments[1].filename).to eq("2.png")

      expect(result[1].id).to eq("2")
      expect(result[1].name).to eq("Simeon")
      expect(result[1].posts.size).to eq(3)

      expect(result[1].posts[0].id).to eq("2")
      expect(result[1].posts[0].text).to eq("hi")
      expect(result[1].posts[0].attachments.size).to eq(2)
      expect(result[1].posts[0].attachments[0].id).to eq("1")
      expect(result[1].posts[0].attachments[0].filename).to eq("1.png")
      expect(result[1].posts[0].attachments[1].id).to eq("2")
      expect(result[1].posts[0].attachments[1].filename).to eq("2.png")

      expect(result[1].posts[1].id).to eq("3")
      expect(result[1].posts[1].text).to eq("how are you?")
      expect(result[1].posts[1].attachments).to eq([])

      expect(result[1].posts[2].id).to eq("1")
      expect(result[1].posts[2].text).to eq("hello")
      expect(result[1].posts[2].attachments.size).to eq(1)
      expect(result[1].posts[2].attachments[0].id).to eq("3")
      expect(result[1].posts[2].attachments[0].filename).to eq("3.png")
    end
  end
end
