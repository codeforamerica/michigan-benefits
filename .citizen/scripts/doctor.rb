class Doctor < CitizenScripts::Doctor
  def run_checks
    # Use built-in default checks, if still desired
    run_default_checks

    # Add a custom check
    check_pdftk
  end

  private

  def check_pdftk
    check(
      name: "pdftk installed",
      command: "which pdftk",
      remedy: "http://www.pdflabs.com/tools/pdftk-server/"
    )
  end
end
