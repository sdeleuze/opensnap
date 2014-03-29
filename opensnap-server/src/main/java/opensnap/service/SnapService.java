package opensnap.service;

import opensnap.domain.Snap;

import java.util.List;

public interface SnapService {
	Snap create(Snap snap);
	Snap getById(int id);
	List<Snap> getSnapsFromRecipient(String username);
	void delete(int id);
	void delete(int id, String username);
}
