RSpec.describe SaveYourselfTheTrip do
  # Ensure that autoincrementing IDs for Building and Apartment will be out of
  # sync.
  let!(:extra_building) { Building.create }

  let!(:building) { Building.create(address: '123 Ruby Street') }
  let!(:apartment) { Apartment.create(building_id: building.id) }

  before { SaveYourselfTheTrip.on! }
  after { SaveYourselfTheTrip.off! }

  context 'redundant query' do
    context 'warn level: :error (default)' do
      it 'raises error' do
        expect{apartment.building.id}.to raise_error(SaveYourselfTheTrip::ExtraTripError, "You called `<Apartment>.building.id`. Better to call `<Apartment>.building_id` and save yourself an extra trip to the database.")
      end
    end

    context 'warn level: :warn' do
      it 'prints warning message' do
        SaveYourselfTheTrip.warn!
        expect{apartment.building.id}.to output("*** EXTRA QUERY DETECTED: You called `<Apartment>.building.id`. Better to call `<Apartment>.building_id` and save yourself an extra trip to the database. ***\n").to_stdout
        SaveYourselfTheTrip.error!
      end
    end
  end

  context 'no redundant query' do
    it 'does not raise error' do
      expect{apartment.building_id}.not_to raise_error
      expect{apartment.building.address}.not_to raise_error
    end
  end
end
