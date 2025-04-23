defmodule FormBuilderDSLTest do
  use ExUnit.Case
  doctest FormBuilderDSL

  setup_all do
    FormBuilderDSL.EnumRegistry.start_link([])
    :ok
  end

  # Test module for enums
  defmodule TestEnums do
    use FormBuilderDSL

    defenum :status, [:approved, :rejected, :pending]
    defenum :roles, [:admin, :user, :guest]
    defenum :categories, [:tech, :science, :arts]
  end

  # Test module for basic form
  defmodule BasicForm do
    use FormBuilderDSL
    alias TestEnums

    form :user do
      text :name
      email :email
      password :password
      select :status, options: TestEnums.status_labeled_options()
    end
  end

  # Test module for advanced form
  defmodule AdvancedForm do
    use FormBuilderDSL
    alias TestEnums

    form :product do
      # Text inputs
      text :name, required: true, placeholder: "Enter product name"
      email :contact_email, required: true
      password :admin_password
      number :price, min: 0, max: 1000, step: 0.01
      tel :phone_number
      url :website
      search :keywords

      # Date and time inputs
      date :release_date
      time :available_time
      date_time :last_updated
      month :target_month
      week :target_week

      # Selection inputs
      select :category, options: TestEnums.categories_labeled_options()
      multi_select :tags, options: TestEnums.categories_labeled_options()
      radio :status, options: TestEnums.status_labeled_options()
      checkbox :featured
      switch :active

      # File inputs
      file :document, accept: ".pdf,.doc,.docx"
      image :product_image

      # Special inputs
      color :theme_color
      range :rating, min: 1, max: 5, step: 1
      hidden :internal_id
    end
  end

  # Test module for form with validations
  defmodule ValidationForm do
    use FormBuilderDSL

    form :user do
      text :name, required: true, validations: [min_length: 3, max_length: 50]
      email :email, required: true, validations: [format: :email]
      number :age, required: true, validations: [min: 18, max: 100]
      select :role, required: true, options: TestEnums.roles_labeled_options()
    end
  end

  # Test module for form with disabled fields
  defmodule DisabledForm do
    use FormBuilderDSL

    form :user do
      text :name, disabled: true
      email :email, disabled: true
      select :role, disabled: true, options: TestEnums.roles_labeled_options()
    end
  end

  # Test module for form with default values
  defmodule DefaultForm do
    use FormBuilderDSL

    form :user do
      text :name, default: "John Doe"
      email :email, default: "john@example.com"
      select :role, default: "user", options: TestEnums.roles_labeled_options()
    end
  end

  # Test basic form functionality
  test "basic form works with text and select inputs" do
    fields = BasicForm.fields()
    assert length(fields) == 4

    name_field = Enum.find(fields, &(&1.key == :name))
    assert name_field.type == :text
    assert name_field.label == "Name"

    email_field = Enum.find(fields, &(&1.key == :email))
    assert email_field.type == :email
    assert email_field.label == "Email"

    password_field = Enum.find(fields, &(&1.key == :password))
    assert password_field.type == :password
    assert password_field.label == "Password"

    status_field = Enum.find(fields, &(&1.key == :status))
    assert status_field.type == :select
    assert status_field.label == "Status"
    assert status_field.options == TestEnums.status_labeled_options()
  end

  # Test advanced form functionality
  test "advanced form supports all input types" do
    fields = AdvancedForm.fields()
    assert length(fields) == 22

    # Test text inputs
    assert Enum.find(fields, &(&1.key == :name)).type == :text
    assert Enum.find(fields, &(&1.key == :contact_email)).type == :email
    assert Enum.find(fields, &(&1.key == :admin_password)).type == :password
    assert Enum.find(fields, &(&1.key == :price)).type == :number
    assert Enum.find(fields, &(&1.key == :phone_number)).type == :tel
    assert Enum.find(fields, &(&1.key == :website)).type == :url
    assert Enum.find(fields, &(&1.key == :keywords)).type == :search

    # Test date and time inputs
    assert Enum.find(fields, &(&1.key == :release_date)).type == :date
    assert Enum.find(fields, &(&1.key == :available_time)).type == :time
    assert Enum.find(fields, &(&1.key == :last_updated)).type == :date_time
    assert Enum.find(fields, &(&1.key == :target_month)).type == :month
    assert Enum.find(fields, &(&1.key == :target_week)).type == :week

    # Test selection inputs
    assert Enum.find(fields, &(&1.key == :category)).type == :select
    assert Enum.find(fields, &(&1.key == :tags)).type == :multi_select
    assert Enum.find(fields, &(&1.key == :status)).type == :radio
    assert Enum.find(fields, &(&1.key == :featured)).type == :checkbox
    assert Enum.find(fields, &(&1.key == :active)).type == :switch

    # Test file inputs
    assert Enum.find(fields, &(&1.key == :document)).type == :file
    assert Enum.find(fields, &(&1.key == :product_image)).type == :image

    # Test special inputs
    assert Enum.find(fields, &(&1.key == :theme_color)).type == :color
    assert Enum.find(fields, &(&1.key == :rating)).type == :range
    assert Enum.find(fields, &(&1.key == :internal_id)).type == :hidden
  end

  # Test form with validations
  test "form supports field validations" do
    fields = ValidationForm.fields()

    name_field = Enum.find(fields, &(&1.key == :name))
    assert name_field.required == true
    assert name_field.validations == [min_length: 3, max_length: 50]

    email_field = Enum.find(fields, &(&1.key == :email))
    assert email_field.required == true
    assert email_field.validations == [format: :email]

    age_field = Enum.find(fields, &(&1.key == :age))
    assert age_field.required == true
    assert age_field.validations == [min: 18, max: 100]
  end

  # Test form with disabled fields
  test "form supports disabled fields" do
    fields = DisabledForm.fields()

    name_field = Enum.find(fields, &(&1.key == :name))
    assert name_field.disabled == true

    email_field = Enum.find(fields, &(&1.key == :email))
    assert email_field.disabled == true

    role_field = Enum.find(fields, &(&1.key == :role))
    assert role_field.disabled == true
  end

  # Test form with default values
  test "form supports default values" do
    fields = DefaultForm.fields()

    name_field = Enum.find(fields, &(&1.key == :name))
    assert name_field.default == "John Doe"

    email_field = Enum.find(fields, &(&1.key == :email))
    assert email_field.default == "john@example.com"

    role_field = Enum.find(fields, &(&1.key == :role))
    assert role_field.default == "user"
  end

  # Test enum functionality
  test "enums work correctly" do
    assert TestEnums.status_labeled_options() == [
             {"Approved", "approved"},
             {"Rejected", "rejected"},
             {"Pending", "pending"}
           ]

    assert TestEnums.roles_labeled_options() == [
             {"Admin", "admin"},
             {"User", "user"},
             {"Guest", "guest"}
           ]

    assert TestEnums.categories_labeled_options() == [
             {"Tech", "tech"},
             {"Science", "science"},
             {"Arts", "arts"}
           ]
  end
end
