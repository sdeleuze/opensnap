package opensnap.service;

import opensnap.domain.Snap;
import org.springframework.util.concurrent.ListenableFuture;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface SnapService {

	CompletableFuture<Snap> create(Snap snap);
	CompletableFuture<Snap> getById(String id);
	CompletableFuture<List<Snap>> getSnapsFromRecipient(String username);
	CompletableFuture<List<Snap>> getSnapsFromAuthor(String username);
	void delete(String id);
	void delete(String id, String username);
}
