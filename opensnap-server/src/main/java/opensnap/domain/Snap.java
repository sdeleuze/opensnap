package opensnap.domain;

import java.util.List;

/** A snap is a photo + duration taken by an author, intended to be viewed by list of recipients **/
public class Snap {

    private int id;
    private User author;
    private List<User> recipients;
    private String photo;
    private int duration;

    Snap() {

    }

    public Snap(int id, User author, List<User> recipients, String photo, int duration) {
        this.id = id;
        this.author = author;
        this.recipients = recipients;
        this.photo = photo;
        this.duration = duration;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public List<User> getRecipients() {
        return recipients;
    }

    public void setRecipient(List<User> recipients) {
        this.recipients = recipients;
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
        if (recipients != null ? !recipients.equals(snap.recipients) : snap.recipients != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id;
        result = 31 * result + (author != null ? author.hashCode() : 0);
        result = 31 * result + (recipients != null ? recipients.hashCode() : 0);
        result = 31 * result + (photo != null ? photo.hashCode() : 0);
        result = 31 * result + duration;
        return result;
    }

	public Snap withoutPhoto() {
		return new Snap(this.id, author, recipients, null, duration);
	}
}
