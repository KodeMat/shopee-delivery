package edu.iacademy.cselec05.pm_rima;

public class DeliveryOrder {
    private String id;
    private String recipientName;
    private String recipientAddress;
    private String recipientPhone;
    private double weight;
    private String status;

    public DeliveryOrder(String id,String recipientName, String recipientAddress, String recipientPhone, double weight, String status ) {
        this.id = id;
        this.recipientName = recipientName;
        this.recipientAddress = recipientAddress;
        this.recipientPhone = recipientPhone;
        this.weight = weight;
        this.status = status;
    }

    public String getId() {
        return id;
    }
    public String getRecipientName() {
        return recipientName;
    }
    public String getRecipientAddress() {
        return recipientAddress;
    }
    public String getRecipientPhone() {
        return recipientPhone;
    }
    public double getWeight() {
        return weight;
    }
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}


