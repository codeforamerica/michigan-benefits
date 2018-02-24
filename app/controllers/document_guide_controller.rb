class DocumentGuideController < SnapStepsController
  include ERB::Util

  def step_class
    NullStep
  end

  def edit
    @doc_guide = {
      unfilled: [],
      today: [],
      soon: [],
      need_help: [],
    }

    @doc_guide[current_application.has_picture_id_for_everyone.to_sym] << "A picture ID for everyone in your household."
    current_application.members.each do |member|
      @doc_guide[member.has_proof_of_income.to_sym] <<
        "Proof of all pay <strong>#{html_escape(member.display_name_or_you)}</strong> received in the last 30 days."
    end
  end
end
