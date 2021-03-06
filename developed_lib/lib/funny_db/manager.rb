module FunnyDb
  class Manager
    OJ_OPTIONS = { symbol_keys: true, time_format: :ruby }.freeze

    def initialize(path_to_db, force_create = true)
      @path_to_db = path_to_db + '.db.json'

      if File.exist? @path_to_db
        load_data_from_file
      elsif force_create
        init_head
        init_body

        save_changes
      else
        raise IOError, 'Database not found'
      end
    end

    def [](group_name)
      DataMapper.new(group_name, self)
    end

    # TODO: Realise work with locked files
    def save_changes
      File.open(@path_to_db, 'w') do |f|
        refresh_hash_in_head

        f.write(jsonified_data)
      end
    end

    private

    def init_head
      @head = {
        hash: '',
        group_count: 0,
        locked: false
      }
    end

    def init_body
      @body = {}
    end

    def composed_data
      result = {
        head: @head,
        body: @body
      }

      result
    end

    def jsonified_data
      Oj.dump(composed_data, OJ_OPTIONS)
    end

    def load_data_from_file
      File.open(@path_to_db, 'r') do |f|
        buf_data = Oj.load(f.read, OJ_OPTIONS)

        @head = buf_data[:head]
        @body = buf_data[:body]
      end
    end

    def calc_hash_of_composed_data
      Digest::SHA256.base64digest(composed_data.to_s)
    end

    def refresh_hash_in_head
      @head[:hash] = ''
      @head[:hash] = calc_hash_of_composed_data
    end

    def changed_data_callback(group_name, changed_data)
      @body[group_name] = Marshal.load(Marshal.dump(changed_data))
    end
  end
end
