class CatRentalRequest < ActiveRecord::Base
  STATUS = ["PENDING", "APPROVED", "DENIED"]

  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: STATUS,
    message: "%{value} is not a valid status" }
  validate :check_for_overlap

  after_initialize { self.status ||= "PENDING" }

  belongs_to :cat

  def approve!
    if status == 'PENDING' && overlapping_approved_requests.to_a.empty?
      self.status = "APPROVED"
      overlaps = overlapping_pending_requests.to_a
      overlaps.each { |request| request.deny }
    end

    CatRentalRequest.transaction do
      self.save!
      overlaps.each { |request| request.save! }
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

  def check_for_overlap
    if status == 'APPROVED' && !overlapping_approved_requests.to_a.empty?
      errors[:status] << "There is an overlapping approved request."
    end
  end

  def overlapping_approved_requests
    overlapping_requests.where("cat_rental_requests.status = 'APPROVED'")
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
