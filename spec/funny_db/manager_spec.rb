# frozen_string_literal: true

describe FunnyDb::Manager do
  let!(:manager_fixture) { structurized_manager_instance_init }
  let(:manager) { manager_fixture.instance }

  describe "#initialize" do
    it "creates a new database file" do
      another_instance = described_class.new(db_path("another_db"))

      expect(another_instance).to be_a(described_class)
      expect(File.exist?(db_path("another_db", for_constructor: false))).to be(true)
    end
  end

  describe "#save_changes" do
    before do
      managertests = manager["managertests"]

      managertests.insert_one(default_data_to_insert)
      managertests.register_all_changes
      manager.save_changes
    end

    it "persists the expected structure to disk" do
      expect(jsonify_db_file).to eq(default_struct_with_expected_group)
    end
  end

  describe "#[]" do
    it "returns a data mapper instance" do
      expect(manager["selected_group"]).to be_a(FunnyDb::DataMapper)
    end
  end

  describe "database file structure" do
    it "matches the default structure after initialization" do
      expect(jsonify_db_file).to eq(default_structure)
    end
  end
end
