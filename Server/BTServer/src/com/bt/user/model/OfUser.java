package com.bt.user.model;

public class OfUser {
	private String username;
	private String plainPassword;
	private String encryptedPassword;
	private String name;
	private String email;
	private String creationDate;
	private String modificationDate;
	public OfUser(String username, String plainPassword,
			String encryptedPassword, String name, String email,
			String creationDate, String modificationDate) {
		super();
		this.username = username;
		this.plainPassword = plainPassword;
		this.encryptedPassword = encryptedPassword;
		this.name = name;
		this.email = email;
		this.creationDate = creationDate;
		this.modificationDate = modificationDate;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPlainPassword() {
		return plainPassword;
	}
	public void setPlainPassword(String plainPassword) {
		this.plainPassword = plainPassword;
	}
	public String getEncryptedPassword() {
		return encryptedPassword;
	}
	public void setEncryptedPassword(String encryptedPassword) {
		this.encryptedPassword = encryptedPassword;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getCreationDate() {
		return creationDate;
	}
	public void setCreationDate(String creationDate) {
		this.creationDate = creationDate;
	}
	public String getModificationDate() {
		return modificationDate;
	}
	public void setModificationDate(String modificationDate) {
		this.modificationDate = modificationDate;
	}
}
