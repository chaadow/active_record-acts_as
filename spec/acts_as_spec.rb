require 'models'

RSpec.describe "ActiveRecord::Base model with #acts_as called" do
  subject { Pen }

  let(:pen_attributes) { {name: 'pen', price: 0.8, color: 'red'} }
  let(:pen) { Pen.new pen_attributes }
  let(:isolated_pen) { IsolatedPen.new color: 'red' }
  let(:store) { Store.new name: 'biggerman' }
  let(:product) { Product.new store: store }

  it "has a has_one relation" do
    association = subject.reflect_on_all_associations.find { |r| r.name == :product }
    expect(association).to_not be_nil
    expect(association.macro).to eq(:has_one)
    expect(association.options).to have_key(:as)
  end

  it "autobuilds the has_one relation" do
    expect(subject.new.product).not_to be_nil
  end

  it "has a cattr_reader for the acting_as_model" do
    expect(subject.acting_as_model).to eq Product
  end

  describe "#acting_as?" do
    it "returns true for supermodel class and name" do
      expect(Pen.acting_as? :product).to be true
      expect(Pen.acting_as? Product).to be true
    end

    it "returns false for anything other than supermodel" do
      expect(Pen.acting_as? :model).to be false
      expect(Pen.acting_as? String).to be false
    end
  end

  describe "#acting_as_reflection" do
    it "returns an activerecord assosiation reflection" do
      expect(Pen.acting_as_reflection).to_not be_nil
      expect(Pen.acting_as_reflection).to be_a(ActiveRecord::Reflection::AssociationReflection)
    end
  end

  describe ".acting_as?" do
    it "returns true for supermodel class and name" do
      expect(pen.acting_as? :product).to be true
      expect(pen.acting_as? Product).to be true
      expect(Inventory::PenLid.is_a? Inventory::ProductFeature).to be true
    end

    it "returns false for anything other than supermodel" do
      expect(pen.acting_as? :model).to be false
      expect(pen.acting_as? String).to be false
    end
  end

  describe "#is_a?" do
    it "responds true when supermodel passed to" do
      expect(Pen.is_a? Product).to be true
      expect(Pen.is_a? Object).to be true
      expect(Pen.is_a? String).to be false
      expect(Inventory::PenLid.is_a? Inventory::ProductFeature).to be true
    end
  end

  describe ".is_a?" do
    it "responds true when supermodel passed to" do
      expect(pen.is_a? Product).to be true
      expect(pen.is_a? Object).to be true
      expect(pen.is_a? String).to be false
    end
  end

  describe "#acting_as_name" do
    it "return acts_as model name" do
      expect(pen.acting_as_name).to eq('product')
    end
  end

  describe "#acting_as" do
    it "builds acts_as model with actable relation set" do
      expect(pen.acting_as).to be_instance_of(Product)
      expect(pen.acting_as.actable).to be_instance_of(Pen)
    end
  end

  describe "#acting_as=" do
    it "sets acts_as model" do
      product = Product.new(name: 'new product', price: 0.99)
      pen = Pen.new
      pen.acting_as = product
      expect(pen.acting_as).to eq(product)
    end
  end

  describe "#dup" do
    it "duplicates actable model as well" do
      p = pen.dup
      expect(p).to be_a Pen
      expect(p.name).to eq('pen')
      expect(p.price).to eq(0.8)
    end
  end

  describe "#has_attribute?" do
    context "when the attribute is defined on the superclass" do
      it "queries the superclass" do
        expect(pen.has_attribute?(:name)).to be_truthy
      end
    end

    context "when the attribute is defined on the subclass" do
      it "queries the subclass" do
        expect(pen.has_attribute?(:color)).to be_truthy
      end
    end
  end

  describe "#column_for_attribute" do
    context "when the attribute is defined on the superclass" do
      it "queries the superclass" do
        expect(pen.column_for_attribute(:name)).to eq(pen.product.column_for_attribute(:name))
      end
    end

    context "when the attribute is defined on the subclass" do
      it "queries the subclass" do
        expect(pen.column_for_attribute(:color)).not_to be_nil
      end
    end
  end

  describe ".validators_on" do
    it "merges the validations on both superclass and subclass" do
      expect(Pen.validators_on(:name, :price)).to contain_exactly(
        *Product.validators_on(:name, :price))
    end
  end

  describe "._reflections" do
    it "merges the reflections on both superclass and subclass" do
      expect(Pen._reflections.length).to eq(Product._reflections.length + 3)
    end
  end

  it "have supermodel attributes accessible on creation" do
    expect{Pen.create(pen_attributes)}.to_not raise_error
  end

  context "instance" do
    it "responds to supermodel methods" do
      %w(name name= name? name_change name_changed? name_was name_will_change! price color).each do |name|
        expect(pen).to respond_to(name)
      end
      expect(pen.present).to eq("pen - $0.8")
    end

    it "responds to supermodel methods with keyword arguments" do
      expect(pen.keyword_method(one: 3, two: 4)).to eq [3,4]
    end

    it 'responds to serialized attribute' do
      expect(pen).to respond_to('option1')
      expect(isolated_pen).to respond_to('option2')
    end

    it 'responds to supermodel serialized attribute' do
      expect(pen).to respond_to('global_option')
      expect(isolated_pen).to respond_to('global_option')
    end

    it 'does not respond to other models serialized attribute' do
      expect(pen).to_not respond_to('option2')
      expect(isolated_pen).to_not respond_to('option1')
    end

    it 'saves supermodel serialized attribute on save' do
      pen.option1 = 'value1'
      pen.global_option = 'globalvalue'
      pen.save
      pen.reload
      isolated_pen.save
      isolated_pen.reload
      expect(pen.option1).to eq('value1')
      expect(isolated_pen).to_not respond_to('option1')
      expect(JSON.parse(pen.to_json)).to eq(JSON.parse('''
        {
          "id": '+ pen.id.to_s + ',
          "name": "pen",
          "price": 0.8,
          "store_id": null,
          "pen_collection_id": null,
          "settings": {"global_option":"globalvalue", "option1":"value1"},
          "color": "red",
          "designed_at": null,
          "created_at": ' + pen.created_at.to_json + ',
          "updated_at": ' + pen.updated_at.to_json + '
        }
      '''))
    end

    it "saves supermodel attributes on save" do
      pen.save
      pen.reload
      expect(pen.name).to eq('pen')
      expect(pen.price).to eq(0.8)
      expect(pen.color).to eq('red')
    end

    context "deleting" do
      it "destroys associated records defined with `has_many dependent: :destroy` on supermodel" do
        pen.save!
        pen.buyers.create!
        expect { pen.destroy }.to change { Buyer.count }.by(-1)
      end

      it "destroys associated records defined with `has_many dependent: :destroy` on submodel" do
        pen.save!
        pen.pen_caps.create!
        expect { pen.destroy }.to change { PenCap.count }.by(-1)
      end
    end

    context 'touching' do
      describe '#touch with arguments' do
        it "forwards supermodel arguments to the supermodel" do
          now = Time.current
          pen.save!
          expect(pen.product).to receive(:touch).with(:updated_at, {time: now})
          pen.touch(:updated_at, time: now)
        end

        it "updates submodel arguments" do
          pen.save!
          expect { pen.touch(:designed_at) }.to change { pen.designed_at }
        end
      end

      describe '#touch without arguments' do
        it "touches the supermodel" do
          pen.save!
          expect(pen.product).to receive(:touch).with(time: nil)
          pen.touch
        end
      end

      describe 'saving' do
        it "touches supermodel on save" do
          pen.save
          pen.reload
          update = pen.product.updated_at
          pen.color = "gray"
          pen.save
          expect(pen.updated_at).not_to eq(update)
        end

        it "does not touch supermodel when no attributes changed" do
          pen.save!
          expect { pen.save! }.to_not change { pen.reload.product.updated_at }
        end

        it "touches belongs_to-touch associations if supermodel is updated" do
          pen.build_pen_collection
          pen.save!
          pen.name = "superpen"
          expect { pen.save! }.to change { pen.pen_collection.updated_at }
        end

        it "touches belongs_to-touch associations of supermodel when submodel is updated" do
          pen.store = store
          pen.save!
          pen.color = "gray"
          expect { pen.save! }.to change { pen.store.updated_at }
        end
      end
    end

    context "polymorphic associations" do
      it "handles them correctly" do
        payment = Payment.new
        pen.payment = payment
        pen.save!
        expect(pen.reload.payment).to       eq(payment)
        expect(pen.payment.payable_type).to eq(pen.acting_as.class.to_s)
        expect(pen.payment.payable_id).to   eq(pen.acting_as.id)
      end
    end

    it "raises NoMethodEror on unexisting method call" do
      expect { pen.unexisted_method }.to raise_error(NoMethodError)
    end

    it "destroys Supermodel on destroy" do
      pen.save
      product_id = pen.product.id
      pen.destroy
      expect { Product.find(product_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context "errors" do
      context 'when validates_actable is set to true' do
        it "combines supermodel and submodel errors" do
          pen = Pen.new
          expect(pen).to be_invalid
          expect(pen.errors.to_hash).to eq(
            name:  ["can't be blank"],
            price: ["can't be blank"],
            color: ["can't be blank"]
          )
          pen.name = 'testing'
          expect(pen).to be_invalid
          expect(pen.errors.to_hash).to eq(
            price: ["can't be blank"],
            color: ["can't be blank"]
          )
          pen.color = 'red'
          expect(pen).to be_invalid
          expect(pen.errors.to_hash).to eq(
            price: ["can't be blank"]
          )
          pen.price = 0.8
          expect(pen).to be_valid
        end
      end

      context 'when validates_actable is set to false' do
        it "unless validates_actable is set to false" do
          pen = IsolatedPen.new
          expect(pen).to be_invalid
          expect(pen.errors.to_hash).to eq(
            color: ["can't be blank"]
          )
          pen.color = 'red'
          expect(pen).to be_valid
        end
      end
    end

    it "can set belongs_to associations defined in supermodel" do
      store.save
      expect(pen.store).to be_nil
      pen.store = store
      pen.save
      pen.reload
      expect(pen.store).to eq(store)
      expect(pen.product.store).to eq(store)
    end

    it "can set has_many associations defined in supermodel" do
      expect(pen.buyers).to be_empty
      buyer = Buyer.create!
      pen.buyers << buyer
      expect(pen.buyers).to eq([buyer])
      expect(pen.product.buyers).to eq([buyer])
    end

    it "can set has_many associations defined in submodel" do
      expect(pen.pen_caps).to be_empty
      pen_cap = PenCap.create!
      pen.pen_caps << pen_cap
      expect(pen.pen_caps).to eq([pen_cap])
    end

    it "should be appendable in an has_many relation using << operator" do
      store.save
      store.products << pen
      expect(pen.store).to eq(store)
    end
  end

  describe "#attributes" do
    it "returns the attribute names of the supermodel and submodel" do
      expect(pen.attributes).to eq(
        "id"                => nil,
        "name"              => "pen",
        "price"             => 0.8,
        "store_id"          => nil,
        "settings"          => {},
        "created_at"        => nil,
        "designed_at"       => nil,
        "updated_at"        => nil,
        "color"             => "red",
        "pen_collection_id" => nil
      )
    end
  end

  describe "#attribute_names" do
    it "returns the attribute names of the supermodel and submodel" do
      expect(pen.attribute_names).to eq(["id", "color", "designed_at", "pen_collection_id", "name", "price", "store_id", "settings", "created_at", "updated_at"])
    end
  end

  describe '#respond.to?' do
    it 'returns true for instance methods of the supermodel and submodel' do
      red_pen = Pen.create!(name: 'red pen', price: 0.8, color: 'red')
      expect(red_pen.respond_to?(:pen_instance_method)).to eq(true)
      expect(red_pen.respond_to?(:present)).to eq(true)
    end
  end

  describe ".actables" do
    before(:each) { clear_database }

    it "returns a query for the actable records" do
      red_pen   = Pen.create!(name: 'red pen',   price: 0.8, color: 'red')
      blue_pen  = Pen.create!(name: 'blue pen',  price: 0.8, color: 'blue')
      _black_pen = Pen.create!(name: 'black pen', price: 0.9, color: 'black')

      actables = Pen.where(price: 0.8).actables

      expect(actables).to be_kind_of(ActiveRecord::Relation)
      expect(actables.to_a).to eq([red_pen.acting_as, blue_pen.acting_as])
    end
  end

  describe '.actable' do
    class User < ActiveRecord::Base
      actable -> { unscope(:where) }
    end

    class Customer < ActiveRecord::Base
      default_scope { where('identifier > 1') }
      acts_as :user

      validates_presence_of :identifier
    end

    context 'with scope' do
      it 'unscopes default scope' do
        customer = Customer.create!(identifier: 1)
        user = customer.user.reload
        expect(user).to be_a User
        expect(user.actable).to eq(customer)
      end
    end
  end

  context 'class methods' do
    before(:each) { clear_database }

    context 'when they are defined via `scope`' do
      it 'can be called from the submodel' do
        _cheap_pen     = Pen.create!(name: 'cheap pen',     price: 0.5, color: 'blue')
        expensive_pen = Pen.create!(name: 'expensive pen', price: 1,   color: 'red')

        expect(Product.with_price_higher_than(0.5).to_a).to eq([expensive_pen.acting_as])
        expect(Pen.with_price_higher_than(0.5).to_a).to eq([expensive_pen])
      end
    end

    context 'when they are not defined via `scope` but made callable by submodel' do
      it 'can be called from the submodel' do
        expect(Product.class_method_callable_by_submodel).to eq('class_method_callable_by_submodel')
        expect(Pen.class_method_callable_by_submodel).to eq('class_method_callable_by_submodel')
      end

      it 'with keyword arguments can be called from the submodel' do
        expect(Pen.class_keyword_method_callable_by_submodel(one: 3, two: 4)).to eq([3,4])
      end
    end

    context 'when they are neither defined via `scope` nor made callable by submodel' do
      it 'cannot be called from the submodel' do
        expect(Product.class_method).to eq('class_method')
        expect { Pen.class_method }.to raise_error(NoMethodError)
      end
    end
  end

  context "Querying" do
    before do
      clear_database

      @red_pen   = Pen.create!(name: 'red pen',   price: 0.8, color: 'red')
      @blue_pen  = Pen.create!(name: 'blue pen',  price: 0.8, color: 'blue')
      @black_pen = Pen.create!(name: 'black pen', price: 0.9, color: 'black')

      @red_pen.pen_caps.create!   size: 'S'
      @blue_pen.pen_caps.create!  size: 'M'
      @black_pen.pen_caps.create! size: 'M'

      @red_pen.buyers.create!   name: 'Tim'
      @blue_pen.buyers.create!  name: 'Tim'
      @black_pen.buyers.create! name: 'John'
    end

    describe '.where and .where!' do
      it 'respects supermodel attributes' do
        conditions = { price: 0.8 }

        expect(Pen.where(conditions).to_a).to eq([@red_pen, @blue_pen])

        relation = Pen.all
        relation.where!(conditions)
        expect(relation.to_a).to eq([@red_pen, @blue_pen])
      end

      it 'works with hashes' do
        conditions = {
          pen_caps: { size: 'M' },
          buyers: { name: 'Tim' }
        }

        expect(Pen.joins(:pen_caps, :buyers).where(conditions).to_a).to eq([@blue_pen])

        relation = Pen.joins(:pen_caps, :buyers)
        relation.where!(conditions)
        expect(relation.to_a).to eq([@blue_pen])
      end
    end

    describe 'relational methods' do
      it "allows relational members in query conditions" do
        magenta_collection = PenCollection.new
        magenta_pen = magenta_collection.pens.build(color: "magenta", price: 1.0, name: "magenta")
        magenta_collection.save!

        expect(Pen.where(pen_collection: magenta_pen.pen_collection).take!).to eq(magenta_pen)
      end
    end

    describe '.find_by' do
      it 'respects supermodel attributes' do
        expect(Pen.find_by(name: 'red pen')).to   eq(@red_pen)
        expect(Pen.find_by(name: 'blue pen')).to  eq(@blue_pen)
        expect(Pen.find_by(name: 'black pen')).to eq(@black_pen)
      end

      it 'works with specifying the table name' do
        expect(Pen.find_by('pens.color' => 'red')).to eq(@red_pen)
      end
    end

    describe '.scope_for_create' do
      it 'includes supermodel attributes' do
        relation = Pen.where(name: 'new name', price: 1.4, color: 'red')

        expect(relation.scope_for_create).to include('name')
        expect(relation.scope_for_create['name']).to eq('new name')
      end
    end
  end

  context 'Namespaces' do
    subject { Inventory::PenLid }

    it "has a has_one relation" do
      association = subject.reflect_on_all_associations.find { |r| r.name == :product_feature }
      expect(association).to_not be_nil
      expect(association.macro).to eq(:has_one)
      expect(association.options).to have_key(:as)
    end

    it "has a cattr_reader for the acting_as_model" do
      expect(subject.acting_as_model).to eq Inventory::ProductFeature
    end

    it "can be created" do
       expect(
         Inventory::PenLid.create name: 'steve',
                                  price: 10.1,
                                  color: 'beige'
      ).to be_a_kind_of Inventory::PenLid
     end
  end

  context 'different association_methods' do
    before(:each) do
      Object.send(:remove_const, :Pen)
    end

    it "should include the selected attribute when associating using 'eager_load'" do
      class Pen < ActiveRecord::Base
        acts_as :product , {association_method: :eager_load}
        store_accessor :settings, :option1
        validates_presence_of :color
      end
      Pen.create pen_attributes

      expect(Pen.select("'something' as thing").first['thing']).to eq 'something'
    end

    it "should include the selected attribute in the model when associating using 'includes'" do
      class Pen < ActiveRecord::Base
        acts_as :product , {association_method: :includes}
        store_accessor :settings, :option1
        validates_presence_of :color
      end
      Pen.create pen_attributes

      expect(Pen.select("'something' as thing").first['thing']).to eq 'something'
    end

    it "should include the selected attribute in the model not specifying an association_method" do
      class Pen < ActiveRecord::Base
        acts_as :product
        store_accessor :settings, :option1
        validates_presence_of :color
      end
      Pen.create pen_attributes

      expect(Pen.select("'something' as thing").first['thing']).to eq 'something'
    end

    it "should include a selected attribute from the parent when associating using 'joins'" do
      class Pen < ActiveRecord::Base
        acts_as :product, {association_method: :joins}
        store_accessor :settings, :option1
        validates_presence_of :color
      end
      Pen.create pen_attributes

      expect(Pen.select("price as thing").first['thing']).to eq 0.8
    end
  end
end
