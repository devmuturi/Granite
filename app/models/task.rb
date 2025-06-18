class Task < ApplicationRecord
  MAX_TITLE_LENGTH = 50
  VALID_TITLE_REGEX = /\A.*[a-zA-Z0-9].*\z/i

  validates :title, presence: true,
            length: { maximum: MAX_TITLE_LENGTH },
            format: { with: VALID_TITLE_REGEX }

  validates :slug, uniqueness: true
  validate :slug_not_changed

  before_create :set_slug

  private

# This method sets a unique, URL-friendly slug for a Task based on its title.
# It ensures no two tasks have the same slug by appending a number when necessary.
  def set_slug
    # Step 1: Convert the task's title into a slug format (e.g., "Write Specs" → "write-specs")
    title_slug = title.parameterize

    # Step 2: Create a regex-based SQL condition for matching similar slugs.
    # Constants::DB_REGEX_OPERATOR should resolve to the correct REGEXP operator depending on the database adapter.
    # For SQLite it might be 'REGEXP', for PostgreSQL it might be '~', etc.
    regex_pattern = "slug #{Constants::DB_REGEX_OPERATOR} ?"

    # Step 3: Query the database for the most recently created slug that either:
    # - Exactly matches the generated base slug (e.g., "write-specs")
    # - Or starts with the base slug followed by a dash and number (e.g., "write-specs-2", "write-specs-10")
    latest_task_slug = Task.where(
      regex_pattern,
      "^#{title_slug}$|^#{title_slug}-[0-9]+$"
    )
    # Sort results by:
    # - Slug length (longest first to catch things like "-10" before "-2")
    # - Slug string itself, descending
    .order("LENGTH(slug) DESC", slug: :desc)
    .first&.slug

    # Step 4: Initialize the slug counter
    slug_count = 0

    # Step 5: If a similar slug was found in the DB, extract its numeric suffix
    if latest_task_slug.present?
      # Try to get the last part after the dash (e.g., "10" from "write-specs-10")
      slug_count = latest_task_slug.split("-").last.to_i

      # If the extracted part is not numeric (i.e., it's the first slug with no number), treat it as 1
      only_one_slug_exists = slug_count == 0
      slug_count = 1 if only_one_slug_exists
    end

    # Step 6: Construct the new unique slug:
    # - If a similar slug exists, append the next number (e.g., "write-specs-3")
    # - If not, use the base slug (e.g., "write-specs")
    slug_candidate = slug_count.positive? ? "#{title_slug}-#{slug_count + 1}" : title_slug

    # Step 7: Assign the generated slug to the current Task
    self.slug = slug_candidate
  end


  def slug_not_changed
    if will_save_change_to_slug? && self.persisted?
      errors.add(:slug, I18n.t("task.slug.immutable"))
    end
  end
end