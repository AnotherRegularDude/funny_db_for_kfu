module FunnyDb
  class Manager
    # TODO: Think about attribute readers: remove or not
    attr_reader :head
    attr_reader :body
    attr_reader :path_to_db
    attr_reader :oj_options

    def initialize(path_to_db, force_create = true)
      @path_to_db = path_to_db + '.db.json'
      declare_oj_options

      if File.exist? @path_to_db
        # TODO: Make it work!
      elsif force_create
        init_head
        init_body

        save_changes
      else
        raise IOError, 'Database not found'
      end
    end

    # TODO: Realise work with locked files
    def save_changes
      File.open(path_to_db, 'w') do |f|
        refresh_hash_in_head

        f.write(jsonified_data)
      end
    end

    private

    def init_head
      @head = {
        hash: '',
        table_count: 0,
        locked: false,
        table_typings: [
        ]
      }
    end

    def init_body
      @body = {}
    end

    def declare_oj_options
      @oj_options = { indent: 2, symbol_keys: true, time_format: :ruby }
    end

    def composed_data
      result = {
        head: head,
        body: body
      }

      result
    end

    def jsonified_data
      Oj.dump(composed_data, oj_options)
    end

    def calc_hash_of_composed_data
      Digest::SHA256.base64digest(composed_data.to_s)
    end

    def refresh_hash_in_head
      head[:hash] = ''
      head[:hash] = calc_hash_of_composed_data
    end
  end
end
