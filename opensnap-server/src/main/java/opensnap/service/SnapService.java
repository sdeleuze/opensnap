package opensnap.service;

import opensnap.domain.Snap;

import java.util.Set;

public interface SnapService {

	Snap create(Snap snap);
	Snap getById(int id);
	Set<Snap> getSnapsFromRecipient(String username);
	void delete(int id);
	void delete(int id, String username);
}
