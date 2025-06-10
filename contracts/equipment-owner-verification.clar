;; Equipment Owner Verification Contract
;; Validates and manages mining equipment owners

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_VERIFIED (err u101))
(define-constant ERR_NOT_FOUND (err u102))
(define-constant ERR_INVALID_EQUIPMENT (err u103))

;; Data structures
(define-map verified-owners principal bool)
(define-map equipment-registry
  { equipment-id: uint }
  {
    owner: principal,
    equipment-type: (string-ascii 50),
    serial-number: (string-ascii 100),
    verified: bool,
    registration-block: uint
  }
)
(define-data-var next-equipment-id uint u1)

;; Verify equipment owner
(define-public (verify-owner (owner principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (is-none (map-get? verified-owners owner)) ERR_ALREADY_VERIFIED)
    (map-set verified-owners owner true)
    (ok true)
  )
)

;; Register equipment
(define-public (register-equipment (equipment-type (string-ascii 50)) (serial-number (string-ascii 100)))
  (let ((equipment-id (var-get next-equipment-id)))
    (asserts! (default-to false (map-get? verified-owners tx-sender)) ERR_UNAUTHORIZED)
    (map-set equipment-registry
      { equipment-id: equipment-id }
      {
        owner: tx-sender,
        equipment-type: equipment-type,
        serial-number: serial-number,
        verified: true,
        registration-block: block-height
      }
    )
    (var-set next-equipment-id (+ equipment-id u1))
    (ok equipment-id)
  )
)

;; Check if owner is verified
(define-read-only (is-verified-owner (owner principal))
  (default-to false (map-get? verified-owners owner))
)

;; Get equipment details
(define-read-only (get-equipment (equipment-id uint))
  (map-get? equipment-registry { equipment-id: equipment-id })
)

;; Get next equipment ID
(define-read-only (get-next-equipment-id)
  (var-get next-equipment-id)
)
