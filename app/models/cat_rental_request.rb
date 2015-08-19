class CatRentalRequest < ActiveRecord::Base
  STATUS = ["PENDING", "APPROVED", "DENIED"]

  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validates :status, inclusion: { in: STATUS,
    message: "%{value} is not a valid status" }
  validate :check_for_overlap, :check_end_date_after_start_date

  after_initialize :set_initial_status

  belongs_to :cat

  belongs_to :requester,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  def approve!
    if status == 'PENDING' && overlapping_approved_requests.to_a.empty?
      self.status = "APPROVED"
      overlaps = overlapping_pending_requests.to_a
      overlaps.each { |request| request.deny }
    end

    CatRentalRequest.transaction do
      self.save!
      overlaps.each { |request| request.save! } if overlaps
    end
  end

  def deny!
    self.deny
    self.save!
  end

  def deny
    self.status = "DENIED" if status == 'PENDING'
  end

  def pending?
    status=="PENDING"
  end

  private
  def set_initial_status
    self.status ||= "PENDING"
    if has_overlapping_approved_requests?
      self.status = "DENIED"
    end
  end

  def check_for_overlap
    if status == 'APPROVED' && has_overlapping_approved_requests?
      errors[:status] << "There is an overlapping approved request."
    end
  end

  def check_end_date_after_start_date
    return if start_date.nil? || end_date.nil?
    if start_date > end_date
      errors[:start_date] << "Must be before end date"
      errors[:end_date] << "Must be after start date"
    end
  end

  def overlapping_approved_requests
    overlapping_requests.where("cat_rental_requests.status = 'APPROVED'")
  end

  def has_overlapping_approved_requests?
    !overlapping_approved_requests.to_a.empty?
  end

  def overlapping_pending_requests
    overlapping_requests.where("cat_rental_requests.status = 'PENDING'")
  end

  def overlapping_requests
    where_condition = <<-SQL
      cat_rental_requests.cat_id = ?
      AND cat_rental_requests.start_date <= ?
      AND cat_rental_requests.end_date >= ?
      AND cat_rental_requests.id <> ?
    SQL

    CatRentalRequest.where(where_condition,cat_id,end_date,start_date,id)
  end
end
