require 'spec_helper'

describe PObject do
  before do
    reset_tmp
  end

  context 'without options' do
    let(:settings) { Settings.new }

    it 'creates a yaml file named as the class' do
      settings.port = 1234
      expect(File).to exist 'settings.yml'
    end

    it 'loads value from file' do
      settings.port = 1234
      new_settings = Settings.new
      expect(new_settings.port).to eq 1234
    end

    it 'allows getting values with hash syntax' do
      settings[:host] = 'localhost'
      expect(settings[:host]).to eq 'localhost'
    end
  end

  context 'with to_store yaml override' do
    let(:product) { Product.new }

    it 'creates the file in the correct place' do
      product.id = 123
      expect(product.store_file).to eq 'spec/tmp/storage.yml'
      expect(File).to exist product.store_file
    end

    it 'loads values from the correct file' do
      product.id = 123
      new_product = Product.new
      expect(new_product.id).to eq 123
    end
  end

  context 'with to_store pstore override' do
    let(:monster) { Monster.new }

    it 'creates the file in the correct place' do
      monster.name = 'Mike Wazowski'
      expect(monster.store_file).to eq 'spec/tmp/monster.pstore'
      expect(File).to exist monster.store_file
    end

    it 'loads values from the correct file' do
      monster.name = 'Mike Wazowski'
      new_monster = Monster.new
      expect(new_monster.name).to eq 'Mike Wazowski'
    end
  end

  context 'with to_store array override' do
    let(:hammer) { Hero.new :hammer }
    let(:raynor) { Hero.new :raynor }

    it 'uses the same file for all instances' do
      hammer.name = 'Sgt. Hammer'
      raynor.name = 'Raynor'
      expect(hammer.store_file).to eq raynor.store_file
    end

    it 'loads values correctly' do
      hammer.name = 'Sgt. Hammer'
      hero = Hero.new :hammer
      expect(hero.name).to eq 'Sgt. Hammer'
    end
  end

  context 'with subsequent calls' do
    it 'updates values' do
      settings = Settings.new
      settings.port = 1234
      expect(settings.port).to eq 1234
      settings.port = 3000
      expect(settings.port).to eq 3000
      expect(Settings.new.port).to eq 3000
    end
  end

  describe '#respond_to_missing' do
    let(:settings) { Settings.new }

    it 'returns true for stored values' do
      settings.port = 3000
      expect(settings.respond_to? :port).to be true
    end

    it 'returns true for all assignments' do
      expect(settings.respond_to? :anything=).to be true
    end

    context 'with allow_missing' do
      it 'returns true for anything' do
        object = Book.new
        expect(object.respond_to? :anything).to be true
      end
    end
  end

  describe '#inspect' do
    let(:settings) { Settings.new }

    it 'returns all stored attributes neatly formatted' do
      settings.host = 'localhost'
      settings.port = 4567
      expected = '<Settings host:localhost, port:4567>'
      expect(settings.inspect).to eq expected
    end

    context 'with to_store array' do
      let(:raynor) { Hero.new :raynor }

      it "returns only the instance's inspect" do
        raynor.name = 'Raynor'
        expect(raynor.inspect).to eq '<Hero name:Raynor>'
      end
    end

    context 'with nested attributes' do
      let(:raynor) { Hero.new :raynor }

      it 'properly presents the nested values' do
        raynor.name = 'Raynor'
        raynor.abilities = ['Inspire', 'Penetrating Rounds']
        expect(raynor.inspect).to eq '<Hero abilities:["Inspire", "Penetrating Rounds"], name:Raynor>'
      end
    end
  end

  describe '#allow_missing' do
    context 'when not set' do
      let(:object) { Settings.new }

      it 'raises error' do
        expect { object.anything }.to raise_error(NoMethodError, /undefined method .anything./)
      end
    end

    context 'when set' do
      let(:object) { Book.new }

      it 'returns nil' do
        expect(object.author).to be_nil
      end

      it 'does not raise error' do
        expect { object.author }.not_to raise_error
      end
    end
  end
end
