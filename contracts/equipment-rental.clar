;; Equipment Rental Contract
;; Manages mining equipment rentals

(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_EQUIPMENT_NOT_AVAILABLE (err u201))
(define-constant ERR_INVALID_RENTAL_PERIOD (err u202))
(define-constant ERR_INSUFFICIENT_PAYMENT (err u203))
(define-constant ERR_RENTAL_NOT_FOUND (err u204))
(define-constant ERR_RENTAL_EXPIRED (err u205))

;; Data structures
(define-map equipment-availability
  { equipment-id: uint }
  {
    available: bool,
    daily-rate: uint,
    owner: principal
  }
)

(define-map active-rentals
  { rental-id: uint }
  {
    equipment-id: uint,
    renter: principal,
    owner: principal,
    start-block: uint,
    end-block: uint,
    daily-rate: uint,
    total-cost: uint,
    active: bool
  }
)

(define-data-var next-rental-id uint u1)

;; List equipment for rent
(define-public (list-equipment (equipment-id uint) (daily-rate uint))
  (begin
    ;; In a real implementation, we'd verify ownership through the verification contract
    (map-set equipment-availability
      { equipment-id: equipment-id }
      {
        available: true,
        daily-rate: daily-rate,
        owner: tx-sender
      }
    )
    (ok true)
  )
)

;; Rent equipment
(define-public (rent-equipment (equipment-id uint) (rental-days uint))
  (let (
    (equipment-info (unwrap! (map-get? equipment-availability { equipment-id: equipment-id }) ERR_EQUIPMENT_NOT_AVAILABLE))
    (rental-id (var-get next-rental-id))
    (total-cost (* (get daily-rate equipment-info) rental-days))
    (end-block (+ block-height (* rental-days u144))) ;; Assuming ~144 blocks per day
  )
    (asserts! (get available equipment-info) ERR_EQUIPMENT_NOT_AVAILABLE)
    (asserts! (> rental-days u0) ERR_INVALID_RENTAL_PERIOD)

    ;; Mark equipment as unavailable
    (map-set equipment-availability
      { equipment-id: equipment-id }
      (merge equipment-info { available: false })
    )

    ;; Create rental record
    (map-set active-rentals
      { rental-id: rental-id }
      {
        equipment-id: equipment-id,
        renter: tx-sender,
        owner: (get owner equipment-info),
        start-block: block-height,
        end-block: end-block,
        daily-rate: (get daily-rate equipment-info),
        total-cost: total-cost,
        active: true
      }
    )

    (var-set next-rental-id (+ rental-id u1))
    (ok rental-id)
  )
)

;; End rental
(define-public (end-rental (rental-id uint))
  (let ((rental-info (unwrap! (map-get? active-rentals { rental-id: rental-id }) ERR_RENTAL_NOT_FOUND)))
    (asserts! (or (is-eq tx-sender (get renter rental-info)) (is-eq tx-sender (get owner rental-info))) ERR_UNAUTHORIZED)
    (asserts! (get active rental-info) ERR_RENTAL_NOT_FOUND)

    ;; Mark rental as inactive
    (map-set active-rentals
      { rental-id: rental-id }
      (merge rental-info { active: false })
    )

    ;; Make equipment available again
    (map-set equipment-availability
      { equipment-id: (get equipment-id rental-info) }
      {
        available: true,
        daily-rate: (get daily-rate rental-info),
        owner: (get owner rental-info)
      }
    )

    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-equipment-availability (equipment-id uint))
  (map-get? equipment-availability { equipment-id: equipment-id })
)

(define-read-only (get-rental-info (rental-id uint))
  (map-get? active-rentals { rental-id: rental-id })
)
