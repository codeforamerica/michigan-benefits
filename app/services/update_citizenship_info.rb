class UpdateCitizenshipInfo
  def run
    SnapApplication.where(everyone_a_citizen: true).find_each do |app|
      app.members.where(citizen: nil).update_all(citizen: true)
    end

    MedicaidApplication.where(everyone_a_citizen: true).find_each do |app|
      app.members.where(citizen: nil).update_all(citizen: true)
    end
  end
end
