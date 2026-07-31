package edu.iacademy.cselec05.pm_rima.model;

import java.io.Serializable;

public class DeliveryOrder implements Serializable {
    private static final long serialVersionUID = 1L;

    private int orderId;
    private String id; // Order tracking number (e.g., ORD-XXXXXX)
    private String recipientName;
    private String recipientAddress;
    private String recipientPhone;
    private double weight;
    private String status;
    private Integer driverId;
    private Integer vehicleId;

    public DeliveryOrder() {
        this.status = "Pending";
    }

    public DeliveryOrder(String id, String recipientName, String recipientAddress, String recipientPhone, double weight, String status) {
        this.id = id;
        this.recipientName = recipientName;
        this.recipientAddress = recipientAddress;
        this.recipientPhone = recipientPhone;
        this.weight = weight;
        this.status = (status != null) ? status : "Pending";
    }

    public DeliveryOrder(int orderId, String id, String recipientName, String recipientAddress, String recipientPhone, double weight, String status, Integer driverId, Integer vehicleId) {
        this.orderId = orderId;
        this.id = id;
        this.recipientName = recipientName;
        this.recipientAddress = recipientAddress;
        this.recipientPhone = recipientPhone;
        this.weight = weight;
        this.status = (status != null) ? status : "Pending";
        this.driverId = driverId;
        this.vehicleId = vehicleId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getRecipientAddress() {
        return recipientAddress;
    }

    public void setRecipientAddress(String recipientAddress) {
        this.recipientAddress = recipientAddress;
    }

    public String getRecipientPhone() {
        return recipientPhone;
    }

    public void setRecipientPhone(String recipientPhone) {
        this.recipientPhone = recipientPhone;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getDriverId() {
        return driverId;
    }

    public void setDriverId(Integer driverId) {
        this.driverId = driverId;
    }

    public Integer getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(Integer vehicleId) {
        this.vehicleId = vehicleId;
    }
}
