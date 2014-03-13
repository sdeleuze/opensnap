package domain;

/** A snap is a photo + duration taken by an author, intended to be viewed by a recipient **/
public class Snap {

    private int id;
    private User author;
    // Manage multiple recipients
    private User recipient;
    private String photo;
    private int duration;

    Snap() {

    }

    public Snap(int id, User author, User recipient, String photo, int duration) {
        this.id = id;
        this.author = author;
        this.recipient = recipient;
        this.photo = photo;
        this.duration = duration;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public User getRecipient() {
        return recipient;
    }

    public void setRecipient(User recipient) {
        this.recipient = recipient;

    }

    /** Base 64 photo **/
    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getId() { return id; }

    public void setId(int id) { this.id = id; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Snap)) return false;

        Snap snap = (Snap) o;

        if (id != snap.id) return false;
        if (duration != snap.duration) return false;
        if (author != null ? !author.equals(snap.author) : snap.author != null) return false;
        if (photo != null ? !photo.equals(snap.photo) : snap.photo != null) return false;
        if (recipient != null ? !recipient.equals(snap.recipient) : snap.recipient != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id;
        result = 31 * result + (author != null ? author.hashCode() : 0);
        result = 31 * result + (recipient != null ? recipient.hashCode() : 0);
        result = 31 * result + (photo != null ? photo.hashCode() : 0);
        result = 31 * result + duration;
        return result;
    }
}
