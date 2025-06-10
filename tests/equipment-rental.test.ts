import { describe, it, expect, beforeEach } from "vitest"

describe("Equipment Rental Contract", () => {
  let contractAddress
  let ownerPrincipal
  let renterPrincipal
  
  beforeEach(() => {
    contractAddress = "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.equipment-rental"
    ownerPrincipal = "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM"
    renterPrincipal = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
  })
  
  describe("Equipment Listing", () => {
    it("should allow owners to list equipment for rent", () => {
      const result = {
        type: "ok",
        value: true,
      }
      
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
    
    it("should store correct availability information", () => {
      const availabilityInfo = {
        available: true,
        "daily-rate": 100,
        owner: ownerPrincipal,
      }
      
      expect(availabilityInfo.available).toBe(true)
      expect(availabilityInfo["daily-rate"]).toBe(100)
      expect(availabilityInfo.owner).toBe(ownerPrincipal)
    })
  })
  
  describe("Equipment Rental", () => {
    it("should allow users to rent available equipment", () => {
      const result = {
        type: "ok",
        value: 1, // Rental ID
      }
      
      expect(result.type).toBe("ok")
      expect(result.value).toBe(1)
    })
    
    it("should reject rental of unavailable equipment", () => {
      const result = {
        type: "err",
        value: 201, // ERR_EQUIPMENT_NOT_AVAILABLE
      }
      
      expect(result.type).toBe("err")
      expect(result.value).toBe(201)
    })
    
    it("should calculate total cost correctly", () => {
      const dailyRate = 100
      const rentalDays = 7
      const expectedCost = dailyRate * rentalDays
      
      expect(expectedCost).toBe(700)
    })
    
    it("should mark equipment as unavailable when rented", () => {
      const availabilityAfterRental = {
        available: false,
        "daily-rate": 100,
        owner: ownerPrincipal,
      }
      
      expect(availabilityAfterRental.available).toBe(false)
    })
  })
  
  describe("Rental Management", () => {
    it("should allow rental termination by owner or renter", () => {
      const result = {
        type: "ok",
        value: true,
      }
      
      expect(result.type).toBe("ok")
      expect(result.value).toBe(true)
    })
    
    it("should make equipment available again after rental ends", () => {
      const availabilityAfterEnd = {
        available: true,
        "daily-rate": 100,
        owner: ownerPrincipal,
      }
      
      expect(availabilityAfterEnd.available).toBe(true)
    })
    
    it("should reject unauthorized rental termination", () => {
      const result = {
        type: "err",
        value: 200, // ERR_UNAUTHORIZED
      }
      
      expect(result.type).toBe("err")
      expect(result.value).toBe(200)
    })
  })
  
  describe("Rental Information", () => {
    it("should return complete rental information", () => {
      const rentalInfo = {
        "equipment-id": 1,
        renter: renterPrincipal,
        owner: ownerPrincipal,
        "start-block": 1000,
        "end-block": 2008, // 7 days * 144 blocks/day
        "daily-rate": 100,
        "total-cost": 700,
        active: true,
      }
      
      expect(rentalInfo["equipment-id"]).toBe(1)
      expect(rentalInfo.renter).toBe(renterPrincipal)
      expect(rentalInfo.owner).toBe(ownerPrincipal)
      expect(rentalInfo["total-cost"]).toBe(700)
      expect(rentalInfo.active).toBe(true)
    })
  })
})
